local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files)
vim.keymap.set('n', 'C-p', builtin.git_files)
vim.keymap.set('n', '<leader>pi', function()
  local term = vim.fn.input('Grep File Contents > ')
  if term == '' then
    return
  end
  builtin.grep_string({ search = term })
end)
