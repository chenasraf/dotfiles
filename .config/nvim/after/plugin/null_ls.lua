local nls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

local function external_format_stdin(filetype, format_cmd)
  if vim.bo.filetype == filetype then
    local buftxt = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    buftxt = buftxt:gsub("%\"", "\\\""):gsub("%$", "\\$")
    local command = "echo -e \"" .. buftxt .. "\" | " .. format_cmd

    local output = vim.fn.system(command)
    local err = vim.v.shell_error
    if err ~= 0 then
      -- vim.api.nvim_err_writeln("Error: " .. err .. ": " .. output)
      error("Error: " .. err .. ": " .. output)
    end

    local lines = vim.split(output, "\n")

    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    return true
  end

  return false
end

local function format()
  local formatters = {
    -- ["lua"] = "lua-format -i",
    -- ["python"] = "black -",
    -- ["sh"] = "shfmt -i 2 -ci -s -bn",
    -- ["javascript"] = "prettier --stdin-filepath ${INPUT}",
    -- ["typescript"] = "prettier --stdin-filepath ${INPUT}",
    -- ["typescriptreact"] = "prettier --stdin-filepath ${INPUT}",
    ["dart"] = "dart format --line-length 120 --output show",
  }

  for filetype, format_cmd in pairs(formatters) do
    if external_format_stdin(filetype, format_cmd) then
      return
    end
  end

  vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
end

vim.keymap.set("n", "<Leader>f", format, { desc = "[nolsp] format" })

nls.setup({
  on_attach = function(client, bufnr)
    -- if client.supports_method("textDocument/formatting") then
    vim.keymap.set("n", "<Leader>f", format, { buffer = bufnr, desc = "[lsp] format" })
    -- format on save
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
    vim.api.nvim_create_autocmd(event, {
      buffer = bufnr,
      group = group,
      callback = format,
      desc = "[lsp] format on save",
    })
    -- end

    -- if client.supports_method("textDocument/rangeFormatting") then
    vim.keymap.set("x", "<Leader>f", format, { buffer = bufnr, desc = "[lsp] format" })
    -- end
  end,
})
