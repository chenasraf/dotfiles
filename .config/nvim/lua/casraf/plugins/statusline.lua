-- vim.keymap.set('n', '<leader>lt', function()
--   -- vim.cmd('so ' .. vim.fn.stdpath('config') .. '/lua/custom/plugins/statusline.lua')
--   print(ts_statusline())
-- end, { noremap = true, silent = true })

local lsp_status = require('casraf.lib.lsp_status')
local ts_keys = require('casraf.lib.ts_keys')

local function wrap_status()
  return (vim.wo.wrap and '✓' or '✗') .. ' TW'
end

local function visual_selection()
  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' and mode ~= '\22' then
    return ''
  end
  local wc = vim.fn.wordcount()
  local chars = wc.visual_chars or 0
  local words = wc.visual_words or 0
  local lines = math.abs(vim.fn.line('v') - vim.fn.line('.')) + 1
  return string.format('%d c | %d w | %d l', chars, words, lines)
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

-- Keep the visual selection counts live as the selection changes
vim.api.nvim_create_autocmd({ 'CursorMoved', 'ModeChanged' }, {
  callback = function()
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' or mode == '\22' then
      require('lualine').refresh()
    end
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
        { visual_selection, color = { fg = '#98c379', gui = 'bold' } },
        ts_keys.ts_statusline,
        lsp_status.lsp_supported,
        wrap_status,
        -- 'encoding',
        -- 'fileformat',
        'filetype'
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
  },
}
