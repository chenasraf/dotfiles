return {
  'MunifTanjim/prettier.nvim',
  dependencies = { 'jose-elias-alvarez/null-ls.nvim' },
  config = function()
    require("prettier").setup({
      bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
      filetypes = {
        "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "less",
        "markdown",
        "scss",
        "typescript",
        "typescriptreact",
        "yaml",
      },
    })

    local nls = require("null-ls")
    local custom_formatting = require("custom.lib.custom_formatting")
    local format_on_save = custom_formatting.format_on_save
    local format_manually = custom_formatting.format_manually

    local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
    local event = "BufWritePre" -- or "BufWritePost"
    -- local async = event == "BufWritePost"

    vim.keymap.set("n", "<Leader>f", format_manually, { desc = "[nolsp] format" })
    vim.keymap.set("n", "=", format_manually, { desc = "[nolsp] format" })

    nls.setup({
      ---@diagnostic disable-next-line: unused-local
      on_attach = function(client, bufnr)
        -- if client.supports_method("textDocument/formatting") then
        vim.keymap.set("n", "<Leader>f", format_manually, { buffer = bufnr, desc = "[lsp] format" })
        -- format on save
        vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
        vim.api.nvim_create_autocmd(event, {
          buffer = bufnr,
          group = group,
          callback = format_on_save,
          desc = "[lsp] format on save",
        })
        -- end

        -- if client.supports_method("textDocument/rangeFormatting") then
        vim.keymap.set("x", "<Leader>f", format_manually, { buffer = bufnr, desc = "[lsp] format" })
        -- end
      end,
    })
  end
}
