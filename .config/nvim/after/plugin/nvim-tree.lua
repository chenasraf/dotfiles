vim.keymap.set("n", "<leader>E", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>e", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })

-- vim.cmd("vnew splitright")

-- empty setup using defaults
-- require("nvim-tree").setup({
--  on_attach = function()
--    vim.cmd("vnew splitright")
--  end,
-- })

-- OR setup with some options
-- require("nvim-tree").setup({
--   sort_by = "case_sensitive",
--   view = {
--     width = 30,
--   },
--   renderer = {
--     group_empty = true,
--   },
--   filters = {
--     dotfiles = true,
--   },
-- })
