vim.api.nvim_create_autocmd("FileType", {
  pattern = "dart",
  callback = function()
    vim.keymap.set("n", "<F5>", ":Telescope flutter commands<CR>", { buffer = true, desc = "Flutter commands" })
  end,
})

return {
  'akinsho/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',     -- optional for vim.ui.select
  },
  config = true,
}
