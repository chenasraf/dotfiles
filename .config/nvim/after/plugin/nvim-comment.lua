require('nvim_comment').setup()

vim.keymap.set("n", "<C-/>", ":CommentToggle<CR>", { noremap = true, silent = true })

