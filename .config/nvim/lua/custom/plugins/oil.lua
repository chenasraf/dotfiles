vim.keymap.set("n", "-", ":Oil<CR>", { desc = "[Oil] Back to parent dir", silent = true })

return {
  'stevearc/oil.nvim',
  opts = {
    view_options = {
      show_hidden = true,
    }
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
