local builtin = require('telescope.builtin')

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'media_files')

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

require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      "node_modules"
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
      '-g', '!.git',
      '-g', '!node_modules'
    },
  },
  extensions = {
    media_files = {
      filetypes = { "png", "webp", "jpg", "jpeg", "svg", "gif", "mp4", "webm", "pdf" },
      -- find command (defaults to `fd`)
      find_cmd = "rg"
    },
  },
  pickers = {
    find_files = {
      find_command = { 'rg', '--files', '--hidden', '-g', '!.git', '-g', '!node_modules' },
    },
  },
  mappings = {
    i = {
      ['<C-u>'] = false,
      ['<C-d>'] = false,
    },
  },
}

return {}
