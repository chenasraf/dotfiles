-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set("n", "Q", "<nop>", { desc = "No Q", silent = true })
vim.keymap.set("n", "<leader>ps", function()
  vim.cmd.write()
  vim.cmd.Ex()
end, { desc = "Save and file explorer", silent = true, silent = true })

--
-- NOTE Remap for dealing with word wrap
--
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

--
-- NOTE pane controls
--
vim.keymap.set("n", "gq", "<C-w>c", { desc = "Close pane", silent = true })
vim.keymap.set("n", "gQ", ":qa!<CR>", { desc = "Close nvim", silent = true })

vim.keymap.set("n", "√", "<C-w>v", { desc = "Split window vertically", silent = true })
vim.keymap.set("n", "ß", "<C-w>s", { desc = "Split window horizontally", silent = true })

--
-- NOTE cursor control
--
vim.keymap.set({ "n", "v" }, "<C-->", "<C-o>", { desc = "Go to previous cursor location", silent = true })
vim.keymap.set({ "n", "v" }, "<C-=>", "<C-i>", { desc = "Go to next cursor location", silent = true })

vim.keymap.set({ "i", "n" }, "<M-Left>", "b", { desc = "Move back word", silent = true })
vim.keymap.set({ "i", "n" }, "<M-Right>", "w", { desc = "Move forward word", silent = true })

--
-- NOTE line manipulations
--
-- move lines up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down", silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up", silent = true })
-- join line - stay on current column
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line", silent = true })

-- insert newlines without insert mode
vim.keymap.set("n", "<M-o>", "o<Esc>k", { desc = "Insert newline below", silent = true })
vim.keymap.set("n", "<M-S-O>", "O<Esc>j", { desc = "Insert newline above", silent = true })

-- insert newlines in insert mode, keep cursor position
vim.keymap.set("i", "<M-o>", "<Esc>o<Esc>gi", { desc = "Insert newline below", silent = true })
vim.keymap.set("i", "<M-S-O>", "<Esc>O<Esc>gi", { desc = "Insert newline above", silent = true })

-- delete words
vim.keymap.set("i", "<A-Backspace>", "<Esc>dbi", { desc = "Delete word backwards", silent = true })
vim.keymap.set("i", "<A-Del>", "<Esc>dei", { desc = "Delete word backwards", silent = true })

-- TODO only apply on JS files
vim.keymap.set("n", "<leader>db", "<esc>dawbx", { desc = "Delete JS property (back)", silent = true })
vim.keymap.set("n", "<leader>dw", "<esc>dawx", { desc = "Delete JS property (fowards)", silent = true })

--
-- NOTE history & clipboard
--
-- redo
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo", silent = true })

-- yank without overwriting register
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste, keep current yank", silent = true })

-- yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank selection to system clipboard", silent = true })

vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file", silent = true })
vim.keymap.set("n", "<leader>W", "<cmd>wa<CR>", { desc = "Save all files", silent = true })

--
-- NOTE find and replace
--
-- search and replace current word
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Search and replace current word" })
-- search and replace current selection
vim.keymap.set("v", "<leader>r", [["hy:%s/<C-r>h/<C-r>h/gI<Left><Left><Left>]],
  { desc = "Search and replace current selection" })

---
--- NOTE general utils/cmds
---

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

--- serve working directory as web server & open in browser
vim.keymap.set("n", "<leader>Srv", function()
  local cmd = "http-server -p 5500"
  vim.cmd(":silent !open http://localhost:5500")
  vim.cmd("belowright split | terminal " .. cmd)
end, { desc = "Serve working directory" })

local function get_current_file_path() return vim.fn.expand('%:p') end
local function get_current_dir_path() return vim.fn.expand('%:p:h') end
local function get_current_file_relative_path() return vim.fn.expand('%') end

--- NOTE working directory/file utils

-- print working directory/file
vim.api.nvim_create_user_command('Pwd', function() print(get_current_dir_path()) end,
  { nargs = 0, desc = "Print working dir" })
vim.api.nvim_create_user_command('Pwf', function() print(get_current_file_relative_path()) end,
  { nargs = 0, desc = "Print current file" })
vim.api.nvim_create_user_command('PwF', function() print(get_current_file_path()) end,
  { nargs = 0, desc = "Print current file (full path)" })

-- yank working directory/file to system clipboard
vim.api.nvim_create_user_command('Ypd', function() vim.fn.setreg('+', get_current_dir_path()) end,
  { nargs = 0, desc = "Yank working dir" })
vim.api.nvim_create_user_command('Ypf', function() vim.fn.setreg('+', get_current_file_relative_path()) end,
  { nargs = 0, desc = "Yank current file" })
vim.api.nvim_create_user_command('YpF', function() vim.fn.setreg('+', get_current_file_path()) end,
  { nargs = 0, desc = "Yank current file (full path)" })

-- NOTE toggle search highlight
local hl_search = vim.o.hlsearch
vim.keymap.set("n", "<leader>n", function()
  hl_search = not hl_search
  print("Search highlight: " .. (hl_search and "on" or "off"))
  vim.o.hlsearch = hl_search
end, { desc = "Toggle search highlight" })

-- NOTE copy json key to system clipboard
local ts_keys = require('casraf.lib.ts_keys')

local function trim(s)
  return s:gsub("^%s+", ""):gsub("%s+$", "")
end

local function copy_wrapped(before, after)
  local key = ts_keys.get_current_keys()
  print("Key: " .. vim.inspect(key), "Before: " .. vim.inspect(before), "After: " .. vim.inspect(after))
  if key then
    key = trim(key)
    before = before and trim(before) or nil
    after = after and trim(after) or nil
    if before then
      key = before .. '.' .. key
    end
    if after then
      key = key .. '.' .. after
    end
    vim.fn.setreg("+", key)
    print('Copied "' .. key .. '" to system clipboard')
  else
    print("No key found")
  end
end

vim.keymap.set('n', '<leader><leader>x', function()
  vim.cmd('%source')
  vim.notify('Sourced current file: ' .. vim.fn.expand('%'), vim.log.levels.INFO)
end, { desc = "Source current file", silent = true })

vim.keymap.set('n', '<leader>x', function()
  vim.cmd('.lua')
  vim.notify('Executed current line as Lua', vim.log.levels.INFO)
end, { desc = "Execute current line", silent = true })

vim.keymap.set('v', '<leader>x', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local start_row, start_col = table.unpack(vim.api.nvim_buf_get_mark(bufnr, '<'))
  local end_row, end_col = table.unpack(vim.api.nvim_buf_get_mark(bufnr, '>'))

  local lines = vim.api.nvim_buf_get_lines(bufnr, start_row - 1, end_row, false)
  lines[1] = string.sub(lines[1], start_col)
  lines[#lines] = string.sub(lines[#lines], 1, end_col)

  local chunk = table.concat(lines, '\n')
  vim.notify('Executed Lua selection', vim.log.levels.INFO)
  ---@diagnostic disable-next-line: param-type-mismatch
  local ok, err = pcall(load(chunk))
  if not ok then
    vim.notify('Lua error: ' .. err, vim.log.levels.ERROR)
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end, { desc = 'Execute selection', silent = true })

vim.keymap.set("n", "<leader>jc", function()
  copy_wrapped(nil, nil)
end, { desc = "Copy key path under cursor to clipboard" })

vim.keymap.set("n", "<leader>ji", function()
  local input = vim.fn.input("Prefix path: ")
  copy_wrapped(input, nil)
end, { desc = "Copy key path under cursor to clipboard (with prefix)" })

vim.keymap.set("n", "<leader>jt", function()
  copy_wrapped('tr', nil)
end, { desc = "Copy key path under cursor to clipboard (tr prefix)" })

vim.keymap.set("n", "<leader>jC", function()
  local key = ts_keys.get_current_keys()
  print("Key: " .. vim.inspect(key))
end, { desc = "Print key path under cursor" })

--- NOTE unused remaps
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
end

return {}
