require('nvim_comment').setup()

vim.keymap.set({"n", "v", "x"}, "<C-/>", ":CommentToggle<CR>", { noremap = true, silent = true })

