require('nvim_comment').setup()

vim.keymap.set({"n", "v", "x"}, "<leader>/", ":CommentToggle<CR>j", { noremap = true, silent = true })

