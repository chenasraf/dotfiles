-- vim.keymap.set('n', '<leader>lt', function()
--   -- vim.cmd('so ' .. vim.fn.stdpath('config') .. '/lua/custom/plugins/statusline.lua')
--   print(ts_statusline())
-- end, { noremap = true, silent = true })

local lsp_status = require('casraf.lib.lsp_status')
local ts_keys = require('casraf.lib.ts_keys')

local function wrap_status()
  return (vim.wo.wrap and '✓' or '✗') .. ' TW'
end

local function macro_recording()
  local reg = vim.fn.reg_recording()
  if reg == '' then
    return ''
  end
  return 'REC @' .. reg
end

-- Refresh lualine immediately when macro recording starts/stops
vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
  callback = function()
    vim.schedule(function()
      require('lualine').refresh()
    end)
  end,
})

return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- See `:help lualine.txt`
  opts = {
    options = {
      icons_enabled = true,
      theme = 'onedark',
      component_separators = '|',
      section_separators = '',
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { 'filename', { macro_recording, color = { fg = '#ff5555', gui = 'bold' } } },
      lualine_d = { 'quickfix' },
      -- lualine_x = { 'require"nvim-treesitter".statusline()', lsp_supported, 'encoding', 'fileformat', 'filetype' },
      lualine_x = {
        ts_keys.ts_statusline,
        lsp_status.lsp_supported,
        wrap_status,
        'encoding',
        'fileformat',
        'filetype'
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
  },
}
