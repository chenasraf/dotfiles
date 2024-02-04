local function notes_search()
  local notes_folder = os.getenv('HOME') .. '/Nextcloud/Notes'
  -- search for notes by file name
  require('telescope.builtin').find_files({
    prompt_title = 'Notes',
    cwd = notes_folder,
    find_command = { 'rg', '--files', '-g', '*.md' },
  })
end

local function create_note()
  local notes_folder = os.getenv('HOME') .. '/Nextcloud/Notes'
  local filename = vim.fn.input('Filename: ')
  if filename == '' then
    return
  end
  local filepath = notes_folder .. '/' .. filename .. '.md'
  vim.cmd('e ' .. filepath)
end

vim.keymap.set('n', '<leader>sN', notes_search, { desc = '[S]earch [N]otes' })
vim.keymap.set('n', '<leader>Cn', create_note, { desc = '[C]reate [N]ote' })

return {}
