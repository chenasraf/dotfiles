-- leader
vim.g.mapleader = " "

-- line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- undo behavior
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- word wrap
vim.opt.wrap = false

-- search
vim.opt.hlsearch = false -- highlight search terms
vim.opt.incsearch = true -- incremental search

-- visual
vim.opt.termguicolors = true
vim.opt.scrolloff = 8 -- always ensure at least 8 lines visible

-- status line
vim.opt.signcolumn = "yes"

-- ???
vim.opt.isfname:append("@-@")

-- ???
vim.opt.updatetime = 50

-- column markers
vim.opt.colorcolumn = { "100", "120" }

-- nvim-tree
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- vim.g.netrw_banner = 0
-- vim.g.netrw_liststyle = 3
-- vim.g.netrw_browse_split = 4
-- vim.g.netrw_altv = 1
-- vim.g.netrw_winsize = 25
-- vim.api.nvim_create_autogroup("ProjectDrawer")
-- vim.api.nvim_create_autocmd("VimEnter", { pattern = "", group = "ProjectDrawer", command = ":Vexplore" })
