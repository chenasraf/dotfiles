return {
  'mg979/vim-visual-multi',
  branch = 'master',
  config = function()
    vim.keymap.set("n", "<M-n>", "<Plug>(VM-Add-Cursor-At-Pos)", { desc = "Add cursor at position" })
  end
}
