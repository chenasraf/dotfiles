-- Shatur/neovim-session-manager
local session_manager = require('session_manager')
local config = require('session_manager.config')

session_manager.setup({
  autoload_mode = config.AutoloadMode.CurrentDir,
})

local config_group = vim.api.nvim_create_augroup('casraf_session', {})

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  group = config_group,
  callback = function()
    if vim.bo.filetype ~= 'git'
        and vim.bo.filetype ~= 'gitcommit'
        and vim.bo.filetype ~= 'gitrebase'
    then
      session_manager.autosave_session()
    end
  end
})

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  group = config_group,
  callback = function()
    if vim.bo.filetype ~= 'git'
        and vim.bo.filetype ~= 'gitcommit'
        and vim.bo.filetype ~= 'gitrebase'
    then
      session_manager.load_current_dir_session()
    end
  end
})
