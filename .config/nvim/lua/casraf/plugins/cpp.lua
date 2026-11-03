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

return {}
