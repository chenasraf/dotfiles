local nls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

local function format()
  if vim.bo.filetype == "dart" then
    local buftxt = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    buftxt = buftxt:gsub("%$", "\\$")
    local command =  "echo -e \"" .. buftxt .. "\" | dart format --line-length 120 --output show"

    local output = vim.fn.system(command)
    local error = vim.v.shell_error
    if error ~= 0 then
      vim.api.nvim_err_writeln("Error: " .. error .. ": " .. output)

      return
    end

    local lines = vim.split(output, "\n")

    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  else
    vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
  end
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

