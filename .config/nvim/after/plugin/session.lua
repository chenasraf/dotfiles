-- Shatur/neovim-session-manager
local session_manager = require('session_manager')
local config = require('session_manager.config')

session_manager.setup({
  autoload_mode = config.AutoloadMode.CurrentDir,
})

local config_group = vim.api.nvim_create_augroup('casraf_session', {})

local autoload = false

local function isnt_special(saving)
  return vim.bo.filetype ~= 'git'
      and vim.bo.filetype ~= 'gitcommit'
      and vim.bo.filetype ~= 'gitrebase'
      and (not saving or vim.fn.stridx(vim.fn.expand('%'), 'oil://') == -1)
end

if autoload then
  vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    group = config_group,
    callback = function()
      if isnt_special(true) then
        session_manager.autosave_session()
      end
    end
  })

  vim.api.nvim_create_autocmd({ 'VimEnter' }, {
    group = config_group,
    callback = function()
      if isnt_special(false) then
        session_manager.load_current_dir_session()
      end
    end
  })
end
