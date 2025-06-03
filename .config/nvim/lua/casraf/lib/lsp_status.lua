local M = {}

M.lsp_supported = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if not clients or vim.tbl_isempty(clients) then
    return '× LSP'
  end

  local supported = {}
  for _, client in ipairs(clients) do
    if type(client.supports_method) == 'function' and (
          client:supports_method('textDocument/codeAction', bufnr) or
          client:supports_method('textDocument/rename', bufnr)
        ) then
      table.insert(supported, client.name)
    end
  end

  if #supported == 0 then
    return '× LSP'
  end

  return '✓ LSP'
end

return M
