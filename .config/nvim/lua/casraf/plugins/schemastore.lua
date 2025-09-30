return {
  "b0o/schemastore.nvim",
  config = function()
    vim.lsp.config.jsonls.setup {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    }
  end
}
