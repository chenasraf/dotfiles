local builtin = require('telescope.builtin')

require('telescope').load_extension('media_files')

vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>pg', builtin.git_files, { desc = 'Git files' })
vim.keymap.set('n', '<leader>pI', function()
  local term = vim.fn.input('Grep File Contents (regex) ⟩ ')
  if term == '' then
    return
  end
  builtin.grep_string({ search = term, use_regex = true })
end)
vim.keymap.set('n', '<leader>pi', function()
  local term = vim.fn.input('Grep File Contents ⟩ ')
  if term == '' then
    return
  end
  builtin.grep_string({ search = term })
end)
