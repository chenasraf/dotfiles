local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

vim.keymap.set('n', '<leader>a', mark.add_file, { desc = "Add file to Harpoon" })
vim.keymap.set('n', '<C-h>', ui.toggle_quick_menu, { desc = "Toggle Harpoon Quick Menu" })
vim.keymap.set('n', '<C-g>', '<Cmd>Telescope harpoon marks<CR>', { desc = "Toggle Harpoon Telescope" })
-- vim.keymap.set('n', '<leader>tt', function() require('harpoon.tmux').gotoTerminal(1) end, { desc = "Quick Terminal 1" })
vim.keymap.set('n', '<C-1>', function() ui.nav_file(1) end, { desc = "Navigate to Harpoon mark 1" })
vim.keymap.set('n', '<C-2>', function() ui.nav_file(2) end, { desc = "Navigate to Harpoon mark 2" })
vim.keymap.set('n', '<C-3>', function() ui.nav_file(3) end, { desc = "Navigate to Harpoon mark 3" })
vim.keymap.set('n', '<C-4>', function() ui.nav_file(4) end, { desc = "Navigate to Harpoon mark 4" })

