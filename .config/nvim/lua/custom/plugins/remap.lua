vim.keymap.set("n", "gq", "<C-w>c", { desc = "Close pane" })

vim.keymap.set({ "n", "v" }, "<C-->", "<C-o>", { desc = "Go to previous cursor location" })
vim.keymap.set({ "n", "v" }, "<C-=>", "<C-i>", { desc = "Go to next cursor location" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

vim.keymap.set("i", "<A-Backspace>", "<Esc>ldbi", { desc = "Delete word backwards" })
vim.keymap.set("i", "<A-Del>", "<Esc>ldei", { desc = "Delete word backwards" })

-- join line - stay on current column
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line" })

-- insert newlines without insert mode
vim.keymap.set("n", "<leader>o", "m`o<Esc>k``j", { desc = "Insert newline below" })
vim.keymap.set("n", "<leader>O", "m`O<Esc>j``k", { desc = "Insert newline above" })

-- redo
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over selection, keep current yank" })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank selection to system clipboard" })

vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

vim.keymap.set("n", "<leader>'", ":ToggleQuotes<CR>", { desc = "Toggle nearest quote" })
-- who needs Q
vim.keymap.set("n", "Q", "<nop>", { desc = "No Q" })

-- buffers
vim.keymap.set("n", "<leader>nh", "<cmd>belowright new<CR>", { desc = "New buffer below" })
vim.keymap.set("n", "<leader>nH", "<cmd>aboveleft new<CR>", { desc = "New buffer above" })
vim.keymap.set("n", "<leader>nV", "<cmd>vnew<CR>", { desc = "New buffer left" })
vim.keymap.set("n", "<leader>nv", "<cmd>belowright vnew<CR>", { desc = "New buffer right" })

-- search and replace current word
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Search and replace current word" })
-- search and replace current selection
vim.keymap.set("v", "<leader>r", [["hy:%s/<C-r>h/<C-r>h/gI<Left><Left><Left>]],
  { desc = "Search and replace current selection" })

-- Jump to next block
vim.keymap.set("n", "<Leader>]", "/{[^}]*$<CR>", { desc = "Jump to next block" })
-- Jump to previous block
vim.keymap.set("n", "<Leader>[", "?{[^}]*$<CR>", { desc = "Jump to previous block" })

vim.keymap.set("n", "<leader>Srv", function()
  local cmd = "http-server -p 5500"
  vim.cmd(":silent !open http://localhost:5500")
  vim.cmd("belowright split | terminal " .. cmd)
end, { desc = "Serve working directory" })

vim.api.nvim_create_user_command('Pwd', function()
  local path = vim.fn.expand('%:p:h')
  path = path:gsub('%n', '')
  vim.cmd("echo '" .. path .. "'")
end, { nargs = 0 })
vim.api.nvim_create_user_command('Pwf', function()
  local path = vim.fn.expand('%:p')
  vim.cmd("echo '" .. path .. "'")
end, { nargs = 0 })

vim.keymap.set("n", "<leader>ps", function()
  vim.cmd.write()
  vim.cmd.Ex()
end, { desc = "Save and file explorer" })


vim.keymap.set("n", "<Leader>cp", ":Copilot panel<CR>", { desc = "Open Copilot panel" })
vim.keymap.set("i", "<F6>", "<Esc>:Copilot panel<CR>i", { desc = "Open Copilot panel" })

-- TODO only apply on JS files
vim.keymap.set("n", "<leader>dp", "<esc>dawbx", { desc = "Delete JS property (forwards)" })
vim.keymap.set("n", "<leader>dP", "<esc>dawx", { desc = "Delete JS property (back)" })

vim.keymap.set({ "n", "v" }, "<F2>", vim.lsp.buf.rename)

local function nope()
  vim.g.mapleader = " "
  -- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "File explorer" })
  vim.keymap.set("n", "<leader>pv", require("oil").open, { desc = "File explorer" })
  vim.keymap.set("n", "-", require("oil").open, { desc = "File explorer" })

  -- vim.keymap.set({"v", "n"}, "<C-.>", "<C-o>", { desc = "Go to previous cursor location" })
  -- vim.keymap.set({"v", "n"}, "<C-,>", "<C-i>", { desc = "Go to next cursor location" })

  -- page up/down
  vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page down" })
  vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page up" })
  -- next find buffer
  vim.keymap.set("n", "n", "nzzzv", { desc = "Next find buffer" })
  -- previous find buffer
  vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous find buffer" })

  vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

  vim.keymap.set("n", "<leader>'", ":ToggleQuotes<CR>", { desc = "Toggle nearest quote" })

  -- comment line
  -- vim.keymap.set("n", "<leader>/", ":CommentToggle<CR>", { desc = "Comment line" })

  vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete selection to void register" })

  -- This is going to get me cancelled
  vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

  vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })
  vim.keymap.set("n", "<leader>X", "<cmd>!chmod -x %<CR>", { silent = true, desc = "Make file not executable" })

  vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/.config/nvim/lua/casraf/packer.lua<CR>",
    { desc = "Edit packer config" });
  vim.keymap.set("n", "<leader>vpr", "<cmd>e ~/.dotfiles/.config/nvim/lua/casraf/remap.lua<CR>",
    { desc = "Edit remaps" });
  -- vim.keymap.set("n", "<leader>mir", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Make it rain" });
  -- vim.keymap.set("n", "<leader>gol", "<cmd>CellularAutomaton game_of_life<CR>", { desc = "Game of life" });

  -- source file
  -- vim.keymap.set("n", "<leader><leader>", ":so<CR>", { desc = "Source current file" })

  -- save file
  vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save buffer" })
  vim.keymap.set("n", "<leader>W", ":wa<CR>", { desc = "Save all buffers" })
end

return {}
