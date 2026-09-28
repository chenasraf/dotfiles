-- The lazygit window lives in a tmux popup, so nvim only dispatches to it.
local function open_lazygit()
  if vim.env.TMUX == nil then
    vim.notify('lazygit runs in a tmux popup — start tmux first', vim.log.levels.WARN)
    return
  end

  vim.system({
    'tmux', 'display-popup', '-E',
    '-d', vim.fn.getcwd(),
    '-w', '90%', '-h', '90%',
    '-b', 'rounded',
    '-T', ' lazygit ',
    'lazygit',
  })
end

vim.keymap.set('n', '<leader>gs', open_lazygit, { desc = 'Lazy[G]it', silent = true })

return {}
