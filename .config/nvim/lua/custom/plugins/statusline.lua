-- vim.keymap.set('n', '<leader>lt', function()
--   -- vim.cmd('so ' .. vim.fn.stdpath('config') .. '/lua/custom/plugins/statusline.lua')
--   print(ts_statusline())
-- end, { noremap = true, silent = true })

local lsp_status = require('custom.lib.lsp_status')
local json_keys = require('custom.lib.json_keys')

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
      lualine_c = { 'filename' },
      -- lualine_x = { 'require"nvim-treesitter".statusline()', lsp_supported, 'encoding', 'fileformat', 'filetype' },
      lualine_x = { json_keys.ts_statusline, lsp_status.lsp_supported, 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
  },
}
