return {
  'stevearc/oil.nvim',
  opts = {
    view_options = {
      show_hidden = true,
    }
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function(opts)
    require("oil").setup(opts)
    vim.keymap.set("n", "-", ":Oil<CR>", { desc = "[Oil] Back to parent dir", silent = true })
  end,
}
