vim.keymap.set('n', '<leader>ca', ':CodeActionMenu<CR>', { desc = '[C]ode [A]ction' })
vim.keymap.set({'n', 'i', 'v'}, '<F4>', '<Esc>:CodeActionMenu<CR>', { desc = '[C]ode [A]ction' })

return {
  'weilbith/nvim-code-action-menu',
  cmd = 'CodeActionMenu',
}
