return {
  'uga-rosa/ccc.nvim',
  opts = {
    highlighter = {
      auto_enable = true,
      lsp = true,
    },
  },
  config = function(opts)
    require('ccc').setup(opts)
  end,
}
