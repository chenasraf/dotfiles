-- <leader>o switches between a C-family source file and its header.

-- Each extension's counterparts, most likely first. The first one names the file
-- created when no counterpart exists.
local counterparts = {
  h = { 'cpp', 'c', 'cc', 'cxx', 'm', 'mm' },
  hh = { 'cc', 'cpp' },
  hpp = { 'cpp', 'cc', 'cxx' },
  hxx = { 'cxx', 'cpp' },
  cuh = { 'cu' },
  c = { 'h' },
  cc = { 'h', 'hh', 'hpp' },
  cpp = { 'h', 'hpp', 'hh' },
  cxx = { 'h', 'hxx', 'hpp' },
  m = { 'h' },
  mm = { 'h' },
  cu = { 'cuh', 'h' },
}

-- `.h` is shared by C, C++ and Objective-C, so a new source file follows the header's filetype.
local new_source_for_h = { c = 'c', objc = 'm', objcpp = 'mm' }

local function edit(path)
  vim.cmd.edit(vim.fn.fnameescape(path))
end

local function switch_source_header()
  local buf = vim.api.nvim_get_current_buf()
  local root, ext = vim.api.nvim_buf_get_name(buf):match('^(.*)%.([^./]+)$')
  local exts = ext and counterparts[ext]
  if not exts then
    vim.notify('Not a C/C++ source or header file', vim.log.levels.WARN)
    return
  end

  for _, e in ipairs(exts) do
    if vim.uv.fs_stat(root .. '.' .. e) then
      return edit(root .. '.' .. e)
    end
  end

  local function create()
    local new_ext = ext == 'h' and new_source_for_h[vim.bo[buf].filetype] or exts[1]
    edit(root .. '.' .. new_ext)
  end

  -- clangd finds counterparts in other directories (include/ vs src/), which the
  -- sibling check above can't.
  local client = vim.lsp.get_clients({ bufnr = buf, name = 'clangd' })[1]
  if not client then
    return create()
  end
  client:request('textDocument/switchSourceHeader', vim.lsp.util.make_text_document_params(buf), function(err, uri)
    if err or not uri then
      return create()
    end
    edit(vim.uri_to_fname(uri))
  end, buf)
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  callback = function(args)
    vim.keymap.set('n', '<leader>o', switch_source_header,
      { buffer = args.buf, desc = 'Switch source/header', silent = true })
  end,
})

-- GCC check on open and save, for projects that keep a GCC compilation database at
-- GCC_DB below their root (`make compile-db` writes one). clangd stays the language
-- server; this adds the real compiler's diagnostics, which clangd misses in places:
-- a static_assert that fails inside a header template instantiated from the file
-- never reaches clangd's diagnostics at all.
--
-- The database isn't at the root or in build/ because clangd would pick it up there,
-- and clangd can't use GCC's flags.

local GCC_DB = '.cache/gcc/compile_commands.json'
local gcc_ns = vim.api.nvim_create_namespace('gcc_check')
local gcc_db_cache = {} -- database path -> { mtime, entries }
local gcc_jobs = {} -- bufnr -> running vim.system handle

local function find_gcc_db(file)
  for dir in vim.fs.parents(file) do
    local path = dir .. '/' .. GCC_DB
    if vim.uv.fs_stat(path) then
      return path
    end
  end
end

local function load_gcc_db(path)
  local stat = vim.uv.fs_stat(path)
  local cached = gcc_db_cache[path]
  if cached and cached.mtime == stat.mtime.sec then
    return cached.entries
  end
  local ok, entries = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), '\n'))
  if not ok then
    return nil
  end
  gcc_db_cache[path] = { mtime = stat.mtime.sec, entries = entries }
  return entries
end

local source_exts = { c = { c = true }, cpp = { cpp = true, cc = true, cxx = true } }

-- The file's own entry, or one from the same directory for headers and files added
-- since the database was written. Every file in a project like this shares one set
-- of flags, so a neighbour's command checks the file as the build would.
local function pick_entry(entries, file, ft)
  local exts = source_exts[ft] or source_exts.cpp
  local dir = vim.fs.dirname(file)
  local same_dir, any
  for _, e in ipairs(entries) do
    if e.file == file then
      return e
    end
    if e.arguments and exts[e.file:match('%.(%w+)$')] then
      if not same_dir and vim.fs.dirname(e.file) == dir then
        same_dir = e
      end
      any = any or e
    end
  end
  return same_dir or any
end

local dropped_with_value = { ['-o'] = true, ['-MF'] = true, ['-MT'] = true, ['-MQ'] = true }
local dropped = { ['-c'] = true, ['-MMD'] = true, ['-MP'] = true, ['-MD'] = true }

local function gcc_args(entry, file, is_header, ft)
  local args = {}
  local skip = false
  for _, a in ipairs(entry.arguments) do
    if skip then
      skip = false
    elseif dropped_with_value[a] then
      skip = true
    elseif not dropped[a] and a ~= entry.file then
      table.insert(args, a)
    end
  end
  -- Toolchains such as devkitARM's live outside PATH, behind an environment variable
  -- the Makefile reads.
  if vim.fn.exepath(args[1]) == '' and vim.env.DEVKITARM then
    args[1] = vim.env.DEVKITARM .. '/bin/' .. args[1]
  end
  vim.list_extend(args, { '-fsyntax-only', '-fdiagnostics-plain-output' })
  if is_header then
    vim.list_extend(args, { '-x', ft == 'c' and 'c' or 'c++' })
  end
  table.insert(args, file)
  return args
end

local gcc_severity = {
  error = vim.diagnostic.severity.ERROR,
  ['fatal error'] = vim.diagnostic.severity.ERROR,
  warning = vim.diagnostic.severity.WARN,
}

-- GCC prints the include and instantiation context before each diagnostic. A
-- diagnostic in another file is shown at the last context line in this file, the way
-- clangd shows errors from included files.
local function parse_gcc(output, file, cwd)
  local real = {}
  local function is_this_file(path)
    if real[path] == nil then
      local abs = path:sub(1, 1) == '/' and path or (cwd .. '/' .. path)
      real[path] = vim.uv.fs_realpath(abs) or abs
    end
    return real[path] == file
  end

  local diags = {}
  local context
  for _, line in ipairs(vim.split(output, '\n', { trimempty = true })) do
    local path, lnum, col, sev, msg = line:match('^(.-):(%d+):(%d+): ([%a ]-): (.*)$')
    if path and gcc_severity[sev] then
      if not msg:match('^#pragma once in main file') then
        local at
        if is_this_file(path) then
          at = { tonumber(lnum), tonumber(col) }
        elseif context then
          at = context
          msg = vim.fs.basename(path) .. ':' .. lnum .. ': ' .. msg
        end
        if at then
          table.insert(diags, {
            lnum = at[1] - 1,
            col = math.max(at[2] - 1, 0),
            severity = gcc_severity[sev],
            source = 'gcc',
            message = msg,
          })
        end
      end
      context = nil
    else
      local cpath, clnum, ccol = line:match('^(.-):(%d+):(%d+):%s+required from')
      if not cpath then
        cpath, clnum = line:match('^In file included from (.-):(%d+)[,:]$')
        if not cpath then
          cpath, clnum = line:match('^%s+from (.-):(%d+)[,:]$')
        end
      end
      if cpath and is_this_file(cpath) then
        context = { tonumber(clnum), tonumber(ccol or 1) }
      end
    end
  end
  return diags
end

local function gcc_check(bufnr)
  local file = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(bufnr))
  local db = file and find_gcc_db(file)
  local entries = db and load_gcc_db(db)
  if not entries then
    return
  end
  -- BufReadPost can run before filetype detection has finished.
  local ft = vim.bo[bufnr].filetype
  if ft == '' then
    ft = file:match('%.c$') and 'c' or 'cpp'
  end
  local entry = pick_entry(entries, file, ft)
  if not entry then
    return
  end
  local is_header = not (source_exts[ft] or source_exts.cpp)[file:match('%.(%w+)$')]
  local cwd = entry.directory

  if gcc_jobs[bufnr] then
    gcc_jobs[bufnr]:kill('sigterm')
  end
  -- Declared first so the exit callback sees this run's handle, and can tell when a
  -- later save has replaced it.
  local job
  local ok = pcall(function()
    job = vim.system(gcc_args(entry, file, is_header, ft), { cwd = cwd, text = true }, function(res)
      vim.schedule(function()
        if gcc_jobs[bufnr] ~= job or not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end
        gcc_jobs[bufnr] = nil
        if res.signal ~= 0 then
          return
        end
        vim.diagnostic.set(gcc_ns, bufnr, parse_gcc(res.stderr or '', file, cwd))
      end)
    end)
  end)
  if ok then
    gcc_jobs[bufnr] = job
  end
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
  pattern = { '*.c', '*.h', '*.cpp', '*.cc', '*.cxx', '*.hpp', '*.hh', '*.hxx' },
  callback = function(args)
    gcc_check(args.buf)
  end,
})

return {}
