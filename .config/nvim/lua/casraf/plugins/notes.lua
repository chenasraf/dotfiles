local notes_folder = os.getenv('HOME') .. '/Nextcloud/Notes'

local function notes_search()
  -- search for notes by file name
  require('fzf-lua').files({
    prompt = 'Notes> ',
    cwd = notes_folder,
    cmd = 'rg --files -g "*.md"',
  })
end

local function create_note()
  local filename = vim.fn.input('Note Name: ')
  if filename == '' then
    return
  end
  local filepath = notes_folder .. '/' .. filename .. '.md'
  vim.cmd('e ' .. filepath)
end

vim.keymap.set('n', '<leader>fN', notes_search, { desc = '[F]ind [N]otes' })
vim.keymap.set('n', '<leader>cn', create_note, { desc = '[C]reate [N]ote' })

return {}
