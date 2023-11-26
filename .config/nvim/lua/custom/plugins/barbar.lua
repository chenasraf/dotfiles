-- Move to previous/next
vim.keymap.set('n', '≤', '<Cmd>BufferPrevious<CR>')
vim.keymap.set('n', '≥', '<Cmd>BufferNext<CR>')
-- Re-order to previous/next
vim.keymap.set('n', '¯', '<Cmd>BufferMovePrevious<CR>')
vim.keymap.set('n', '˘', '<Cmd>BufferMoveNext<CR>')
-- Goto buffer in position...
vim.keymap.set('n', '¡', '<Cmd>BufferGoto 1<CR>')
vim.keymap.set('n', '™', '<Cmd>BufferGoto 2<CR>')
vim.keymap.set('n', '£', '<Cmd>BufferGoto 3<CR>')
vim.keymap.set('n', '¢', '<Cmd>BufferGoto 4<CR>')
vim.keymap.set('n', '∞', '<Cmd>BufferGoto 5<CR>')
vim.keymap.set('n', '§', '<Cmd>BufferGoto 6<CR>')
vim.keymap.set('n', '¶', '<Cmd>BufferGoto 7<CR>')
vim.keymap.set('n', '•', '<Cmd>BufferGoto 8<CR>')
vim.keymap.set('n', 'ª', '<Cmd>BufferGoto 9<CR>')
vim.keymap.set('n', 'º', '<Cmd>BufferLast<CR>')
-- Pin/unpin buffer
vim.keymap.set('n', 'π', '<Cmd>BufferPin<CR>')
-- Close buffer
vim.keymap.set('n', 'ç', '<Cmd>BufferClose<CR>')
-- Close all but current
vim.keymap.set('n', 'Ç', '<Cmd>BufferCloseAllButCurrent<CR>')
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
vim.keymap.set('n', '<C-p>', '<Cmd>BufferPick<CR>')
-- Sort automatically by...
vim.keymap.set('n', '<leader>bb', '<Cmd>BufferOrderByBufferNumber<CR>')
vim.keymap.set('n', '<leader>bd', '<Cmd>BufferOrderByDirectory<CR>')
vim.keymap.set('n', '<leader>bl', '<Cmd>BufferOrderByLanguage<CR>')
vim.keymap.set('n', '<leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>')

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
  opts = {
    -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
    -- animation = true,
    -- insert_at_start = true,
    -- …etc.
  },
  version = '^1.0.0', -- optional: only update when a new 1.x version is released
}
