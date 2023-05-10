vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "File explorer" })
vim.keymap.set("n", "<leader>ps", function()
  vim.cmd.write()
  vim.cmd.Ex()
end, { desc = "Save and file explorer" })

vim.keymap.set("n", "<leader>q", "<C-w>c", { desc = "Close pane" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- vim.keymap.set({"v", "n"}, "<C-.>", "<C-o>", { desc = "Go to previous cursor location" })
-- vim.keymap.set({"v", "n"}, "<C-,>", "<C-i>", { desc = "Go to next cursor location" })

-- join line - stay on current column
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line" })

-- insert newlines without insert mode
vim.keymap.set("n", "<S-CR>", "m`o<Esc>k``", { desc = "Insert newline below" })
vim.keymap.set("n", "<CR>",   "m`O<Esc>j``", { desc = "Insert newline above" })

-- redo
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

-- page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page up" })
-- next find buffer
vim.keymap.set("n", "n", "nzzzv", { desc = "Next find buffer" })
-- previous find buffer
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous find buffer" })

-- vim.keymap.set("n", "<leader>vwm", function()
--   require("vim-with-me").StartVimWithMe()
-- end)
-- vim.keymap.set("n", "<leader>svwm", function()
--   require("vim-with-me").StopVimWithMe()
-- end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over selection, keep current yank" })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank selection to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
-- surround with parens
-- vim.keymap.set("v", "(", "(<C-r>\"<Esc>", { desc = "Surround selection with parens" })

-- comment line
vim.keymap.set("n", "<leader>/", ":CommentToggle<CR>", { desc = "Comment line" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete selection to void register" })

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

-- who needs Q
vim.keymap.set("n", "Q", "<nop>", { desc = "No Q" })

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "New tmux session" })

-- file formatting
-- TODO: move to lsp.lua?
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format file" })
vim.keymap.set("n", "<leader>df", "<cmd>silent !dart format --line-length 120 %:p<CR>",
  { desc = "Format dart file", silent = true })

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list" })

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Search and replace current word" })
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })
vim.keymap.set("n", "<leader>X", "<cmd>!chmod -x %<CR>", { silent = true, desc = "Make file not executable" })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/.dotfiles/nvim/lua/casraf/packer.lua<CR>",
  { desc = "Edit packer config" });
vim.keymap.set("n", "<leader>mir", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Make it rain" });
vim.keymap.set("n", "<leader>gol", "<cmd>CellularAutomaton game_of_life<CR>", { desc = "Game of life" });

-- source file
vim.keymap.set("n", "<leader><leader>", function()
  -- vim.cmd.write()
  vim.cmd("so")
end, { desc = "Source current file" })

-- save file
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save buffer" })
vim.keymap.set("n", "<leader>W", ":wa<CR>", { desc = "Save all buffers" })

vim.keymap.set("n", "<leader>Srv", function()
  local cmd = "python3 -m http.server 5500"
  vim.cmd(":silent !open http://localhost:5500")
  vim.cmd("split | terminal " .. cmd)
end, { desc = "Serve working directory" })
