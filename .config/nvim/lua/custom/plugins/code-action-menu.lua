vim.keymap.set('n', '<leader>ca', ':CodeActionMenu<CR>', { desc = '[C]ode [A]ction', silent = true })
vim.keymap.set('n', 'ga', ':CodeActionMenu<CR>', { desc = '[C]ode [A]ction', silent = true })
vim.keymap.set({ 'n', 'i', 'v' }, '<F4>', '<Esc>:CodeActionMenu<CR>', { desc = '[C]ode [A]ction', silent = true })

return {
  'weilbith/nvim-code-action-menu',
  cmd = 'CodeActionMenu',
}
