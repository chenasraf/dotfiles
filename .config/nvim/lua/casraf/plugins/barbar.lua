-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used


return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  init = function() vim.g.barbar_auto_setup = false end,
  config = function()
    local function apply_barbar_hl()
      local ok, palette = pcall(function() return require('catppuccin.palettes').get_palette() end)
      if not ok then return end
      local set = vim.api.nvim_set_hl
      for _, state in ipairs({ 'Current', 'Visible', 'Inactive', 'Alternate' }) do
        local emphasize = state == 'Current' or state == 'Alternate'
        set(0, 'Buffer' .. state .. 'Mod', { fg = palette.peach, bold = emphasize, italic = true })
        set(0, 'Buffer' .. state .. 'ModBtn', { fg = palette.peach, bold = emphasize })
        set(0, 'Buffer' .. state .. 'ADDED', { fg = palette.green, bold = emphasize })
        set(0, 'Buffer' .. state .. 'CHANGED', { fg = palette.yellow, bold = emphasize })
        set(0, 'Buffer' .. state .. 'DELETED', { fg = palette.red, bold = emphasize })
        set(0, 'Buffer' .. state .. 'ERROR', { fg = palette.red, bold = emphasize })
        set(0, 'Buffer' .. state .. 'WARN', { fg = palette.yellow, bold = emphasize })
        set(0, 'Buffer' .. state .. 'HINT', { fg = palette.teal, bold = emphasize })
      end
    end
    vim.api.nvim_create_autocmd('ColorScheme', { callback = apply_barbar_hl })
    apply_barbar_hl()

    require('barbar').setup({
      icons = {
        filetype = { enabled = true },
        modified = { button = '●' },
        pinned = { button = '', filename = true },
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true, icon = ' ' },
          [vim.diagnostic.severity.WARN] = { enabled = true, icon = ' ' },
          [vim.diagnostic.severity.INFO] = { enabled = false },
          [vim.diagnostic.severity.HINT] = { enabled = true, icon = '󰌶 ' },
        },
        gitsigns = {
          added = { enabled = true, icon = '+' },
          changed = { enabled = true, icon = '~' },
          deleted = { enabled = true, icon = '-' },
        },
      },
    })
    -- Move to previous/next
    vim.keymap.set({ 'n', 'v' }, '<A-[>', '<Cmd>BufferPrevious<CR>')
    vim.keymap.set({ 'n', 'v' }, '<A-]>', '<Cmd>BufferNext<CR>')
    -- Re-order to previous/next
    vim.keymap.set({ 'n', 'v' }, '<A-{>', '<Cmd>BufferMovePrevious<CR>')
    vim.keymap.set({ 'n', 'v' }, '<A-}>', '<Cmd>BufferMoveNext<CR>')
    -- Goto buffer in position...
    -- vim.keymap.set('n', '¡', '<Cmd>BufferGoto 1<CR>')
    -- vim.keymap.set('n', '™', '<Cmd>BufferGoto 2<CR>')
    -- vim.keymap.set('n', '£', '<Cmd>BufferGoto 3<CR>')
    -- vim.keymap.set('n', '¢', '<Cmd>BufferGoto 4<CR>')
    -- vim.keymap.set('n', '∞', '<Cmd>BufferGoto 5<CR>')
    -- vim.keymap.set('n', '§', '<Cmd>BufferGoto 6<CR>')
    -- vim.keymap.set('n', '¶', '<Cmd>BufferGoto 7<CR>')
    -- vim.keymap.set('n', '•', '<Cmd>BufferGoto 8<CR>')
    -- vim.keymap.set('n', 'ª', '<Cmd>BufferGoto 9<CR>')
    -- vim.keymap.set('n', 'º', '<Cmd>BufferLast<CR>')
    -- Pin/unpin buffer
    vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>')
    -- Close buffer
    vim.keymap.set('n', '<A-c>', '<Cmd>BufferClose<CR>')
    -- Close all but current
    vim.keymap.set('n', '<A-C>', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>')
    -- Magic buffer-picking mode
    vim.keymap.set('n', '<C-p>', '<Cmd>BufferPick<CR>')
    -- Wipeout buffer
    --                 :BufferWipeout
    -- Close commands
    --                 :BufferCloseAllButCurrent
    --                 :BufferCloseAllButPinned
    --                 :BufferCloseAllButCurrentOrPinned
    --                 :BufferCloseBuffersLeft
    --                 :BufferCloseBuffersRight
    -- Sort automatically by...
    -- vim.keymap.set('n', '<leader>bn', '<Cmd>BufferOrderByBufferNumber<CR>')
    -- vim.keymap.set('n', '<leader>bd', '<Cmd>BufferOrderByDirectory<CR>')
    -- vim.keymap.set('n', '<leader>bl', '<Cmd>BufferOrderByLanguage<CR>')
    -- vim.keymap.set('n', '<leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>')
  end,
  -- version = '^1.0.0', -- optional: only update when a new 1.x version is released
}
