-- local opts = { noremap = false, silent = true }
local opts = { }

require('barbar').setup({})

-- Move to previous/next
vim.keymap.set('n', '≤', '<Cmd>BufferPrevious<CR>', opts)
vim.keymap.set('n', '≥', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
vim.keymap.set('n', '¯', '<Cmd>BufferMovePrevious<CR>', opts)
vim.keymap.set('n', '˘', '<Cmd>BufferMoveNext<CR>', opts)
-- Goto buffer in position...
vim.keymap.set('n', '¡', '<Cmd>BufferGoto 1<CR>', opts)
vim.keymap.set('n', '™', '<Cmd>BufferGoto 2<CR>', opts)
vim.keymap.set('n', '£>', '<Cmd>BufferGoto 3<CR>', opts)
vim.keymap.set('n', '¢', '<Cmd>BufferGoto 4<CR>', opts)
vim.keymap.set('n', '∞', '<Cmd>BufferGoto 5<CR>', opts)
vim.keymap.set('n', '§', '<Cmd>BufferGoto 6<CR>', opts)
vim.keymap.set('n', '¶', '<Cmd>BufferGoto 7<CR>', opts)
vim.keymap.set('n', '•', '<Cmd>BufferGoto 8<CR>', opts)
vim.keymap.set('n', 'ª', '<Cmd>BufferGoto 9<CR>', opts)
vim.keymap.set('n', 'º', '<Cmd>BufferLast<CR>', opts)
-- Pin/unpin buffer
vim.keymap.set('n', 'π', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
vim.keymap.set('n', 'ç', '<Cmd>BufferClose<CR>', opts)
-- Close all but current
vim.keymap.set('n', '<C-†>', '<Cmd>BufferCloseAllButCurrent<CR>', opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
vim.keymap.set('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
-- Sort automatically by...
vim.keymap.set('n', '<leader>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
vim.keymap.set('n', '<leader>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
vim.keymap.set('n', '<leader>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
vim.keymap.set('n', '<leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used

