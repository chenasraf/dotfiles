local function read_file(path)
  if vim.fn.filereadable(path) ~= 1 then
    return nil
  end
  return vim.fn.readfile(path)
end

-- Nearest `name` in the buffer's directory or above, never reaching $HOME itself
local function find_up(name, buf)
  local fname = vim.api.nvim_buf_get_name(buf)
  local start = fname ~= '' and vim.fs.dirname(fname) or vim.fn.getcwd()
  return vim.fs.find(name, { upward = true, path = start, stop = vim.loop.os_homedir(), type = 'file' })[1]
end

local function exists(dir, name)
  return vim.fn.filereadable(dir .. '/' .. name) == 1
end

local function js_package_manager(dir, pkg)
  if type(pkg.packageManager) == 'string' then
    local pm = pkg.packageManager:match('^[^@]+')
    if pm then
      return pm
    end
  end
  if type(pkg.engines) == 'table' then
    for _, pm in ipairs({ 'pnpm', 'yarn', 'npm' }) do
      if pkg.engines[pm] then
        return pm
      end
    end
  end
  if exists(dir, 'pnpm-lock.yaml') then
    return 'pnpm'
  elseif exists(dir, 'yarn.lock') then
    return 'yarn'
  elseif exists(dir, 'bun.lockb') or exists(dir, 'bun.lock') then
    return 'bun'
  end
  return 'npm'
end

local function collect_js(path)
  local lines = read_file(path)
  if not lines then
    return {}
  end
  local ok, pkg = pcall(vim.json.decode, table.concat(lines, '\n'))
  if not ok or type(pkg) ~= 'table' or type(pkg.scripts) ~= 'table' then
    return {}
  end

  local dir = vim.fs.dirname(path)
  local pm = js_package_manager(dir, pkg)
  local names = vim.tbl_keys(pkg.scripts)
  table.sort(names)

  local entries = {}
  for _, name in ipairs(names) do
    local cmd = pm .. ' run ' .. name
    table.insert(entries, { label = cmd, value = cmd, dir = dir })
  end
  return entries
end

-- Poe tasks win over [project.scripts] when both exist, as there is no telling
-- which of them is the project's entry point
local function collect_py(path)
  local lines = read_file(path)
  if not lines then
    return {}
  end

  local poe, scripts, section = {}, {}, nil
  for _, line in ipairs(lines) do
    local header = line:match('^%[([^%[%]]+)%]%s*$')
    if header then
      section = vim.trim(header)
      local task = section:match('^tool%.poe%.tasks%.([%w_%-]+)$')
      if task then
        table.insert(poe, task)
      end
    elseif line:match('^%[') then
      section = nil
    else
      local key = line:match('^["\']?([%w_%-]+)["\']?%s*=')
      if key and section == 'tool.poe.tasks' then
        table.insert(poe, key)
      elseif key and section == 'project.scripts' then
        table.insert(scripts, key)
      end
    end
  end

  local dir = vim.fs.dirname(path)
  local runner
  if #poe > 0 then
    runner = 'poe'
  elseif exists(dir, 'poetry.lock') then
    runner = 'poetry run'
  elseif exists(dir, 'uv.lock') then
    runner = 'uv run'
  else
    runner = 'python -m'
  end

  local entries = {}
  for _, name in ipairs(#poe > 0 and poe or scripts) do
    local cmd = runner .. ' ' .. name
    table.insert(entries, { label = cmd, value = cmd, dir = dir })
  end
  return entries
end

local function collect_make(path)
  local lines = read_file(path)
  if not lines then
    return {}
  end

  local dir = vim.fs.dirname(path)
  local seen, entries = {}, {}
  for _, line in ipairs(lines) do
    local target = line:match('^([%w][%w_%-]*):')
    -- `FOO:=bar` is a variable assignment, not a target
    if target and not line:match('^[%w_%-]+:+=') and not seen[target] then
      seen[target] = true
      local cmd = 'make ' .. target
      table.insert(entries, { label = cmd, value = cmd, dir = dir })
    end
  end
  return entries
end

local function collect_cargo(path)
  local dir = vim.fs.dirname(path)
  local entries = {}
  for _, cmd in ipairs({
    'cargo run',
    'cargo test',
    'cargo build',
    'cargo run --release',
    'cargo test --release',
    'cargo build --release',
  }) do
    table.insert(entries, { label = cmd, value = cmd, dir = dir })
  end
  return entries
end

-- `go run .` only exists when the module root is itself a main package; commands under
-- cmd/ are the usual home of the rest
local function collect_go(path)
  local dir = vim.fs.dirname(path)
  local cmds = {}

  for _, file in ipairs(vim.fn.glob(dir .. '/*.go', false, true)) do
    local head = vim.fn.readfile(file, '', 50)
    if vim.iter(head):any(function(line) return line:match('^package%s+main%s*$') end) then
      table.insert(cmds, 'go run .')
      break
    end
  end

  local names = {}
  for name, kind in vim.fs.dir(dir .. '/cmd') do
    if kind == 'directory' then
      table.insert(names, name)
    end
  end
  table.sort(names)
  for _, name in ipairs(names) do
    table.insert(cmds, 'go run ./cmd/' .. name)
  end

  vim.list_extend(cmds, { 'go test ./...', 'go build ./...', 'go vet ./...' })

  local entries = {}
  for _, cmd in ipairs(cmds) do
    table.insert(entries, { label = cmd, value = cmd, dir = dir })
  end
  return entries
end

local manifests = {
  { file = 'package.json',   collect = collect_js },
  { file = 'pyproject.toml', collect = collect_py },
  { file = 'Makefile',       collect = collect_make },
  { file = 'Cargo.toml',     collect = collect_cargo },
  { file = 'go.mod',         collect = collect_go },
}

-- Commands that belong to a filetype rather than to a project manifest
local filetype_entries = {
  lua = function(buf)
    local filename = vim.api.nvim_buf_get_name(buf)
    return {
      { label = 'Run file',    value = 'lua ' .. filename,    type = 'cmd' },
      { label = 'Source file', value = 'source ' .. filename, type = 'cmd' },
    }
  end,
}

local function collect(buf)
  local entries, seen = {}, {}
  local function add(list)
    for _, entry in ipairs(list) do
      if not seen[entry.label] then
        seen[entry.label] = true
        table.insert(entries, entry)
      end
    end
  end

  local by_filetype = filetype_entries[vim.bo[buf].filetype]
  if by_filetype then
    add(by_filetype(buf))
  end
  for _, manifest in ipairs(manifests) do
    local path = find_up(manifest.file, buf)
    if path then
      add(manifest.collect(path))
    end
  end
  return entries
end

local function run_entry(entry)
  if entry.fn then
    entry.fn()
  elseif entry.type == 'cmd' then
    vim.cmd(entry.value)
  else
    -- `lcd` runs in the new split only, so the command starts in the manifest's directory
    local lcd = entry.dir and ('lcd ' .. vim.fn.fnameescape(entry.dir) .. ' | ') or ''
    vim.cmd('split | wincmd J | resize 20 | ' .. lcd .. 'terminal ' .. entry.value)
  end
end

local function pick(buf)
  local entries = collect(buf)

  -- <F5> shadows dap's start/continue map in buffers that have a picker
  local dap = package.loaded['dap']
  if dap and next(dap.configurations[vim.bo[buf].filetype] or {}) then
    table.insert(entries, { label = 'Debug: Start/Continue', fn = dap.continue })
  end

  if #entries == 0 then
    vim.notify('No runnable scripts found', vim.log.levels.INFO)
    return
  end

  local labels, by_label = {}, {}
  for _, entry in ipairs(entries) do
    table.insert(labels, entry.label)
    by_label[entry.label] = entry
  end

  require('fzf-lua').fzf_exec(labels, {
    prompt = 'Select run configuration> ',
    winopts = {
      width = 0.4,
      height = 0.4,
    },
    actions = {
      ['default'] = function(selected)
        local entry = selected and selected[1] and by_label[selected[1]]
        if entry then
          run_entry(entry)
        end
      end,
    },
  })
end

local group = vim.api.nvim_create_augroup("casraf_project_runner", {})
vim.api.nvim_clear_autocmds({ group = group })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(args)
    if vim.bo[args.buf].buftype ~= '' or #collect(args.buf) == 0 then
      return
    end
    vim.keymap.set("n", "<F5>", function() pick(args.buf) end, { buffer = args.buf, desc = "Run project commands" })
  end,
})

return {}
