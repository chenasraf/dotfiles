return {
  "liangxianzhe/floating-input.nvim",
  config = function()
    vim.ui.input = function(opts, on_confirm)
      require("floating-input").input(opts, on_confirm, { border = 'double' })
    end
  end
}
