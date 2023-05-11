vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "File explorer" })
vim.keymap.set("n", "<leader>ps", function()
  vim.cmd.write()
  vim.cmd.Ex()
end, { desc = "Save and file explorer" })

vim.keymap.set("n", "<leader>Q", "<C-w>c", { desc = "Close pane" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- vim.keymap.set({"v", "n"}, "<C-.>", "<C-o>", { desc = "Go to previous cursor location" })
-- vim.keymap.set({"v", "n"}, "<C-,>", "<C-i>", { desc = "Go to next cursor location" })

-- join line - stay on current column
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line" })

-- insert newlines without insert mode
vim.keymap.set("n", "<CR>", "m`o<Esc>k``", { desc = "Insert newline below" })
vim.keymap.set("n", "<M-Enter>", "m`O<Esc>j``", { desc = "Insert newline above" })

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
vim.keymap.set("v", "<leader>(", [[:s/\%V\(.*\)\%V/\(\1\)/g<Left><Left><CR>]],
  { desc = "Surround selection with parens" })
vim.keymap.set("v", "<leader>[[", [[:s/\%V\(.*\)\%V/\[\1\]/g<Left><Left><CR>]],
  { desc = "Surround selection with brackets" })
vim.keymap.set("v", "<leader>{", [[:s/\%V\(.*\)\%V/{\1}/g<Left><Left><CR>]], { desc = "Surround selection with braces" })
vim.keymap.set("v", "<leader><", [[:s/\%V\(.*\)\%V/<\1>/g<Left><Left><CR>]],
  { desc = "Surround selection with angle brackets" })

vim.keymap.set("n", "<leader>'", ":ToggleQuotes", { desc = "Toggle nearest quote" })

-- replace nearest quote with double quote
-- vim.keymap.set("n", "<leader>'", function()
--     -- save original position
--     local orig_pos = vim.fn.getpos(".")
--     local orig_line = orig_pos[2]
--
--     -- look for nearest quote before, iterate lines until match found
--     local line = vim.fn.line(".")
--     local col = vim.fn.col(".")
--     local found = false
--     local quote_type = ""
--     -- print("line", line, "col", col)
--     while line > 0 do
--       local line_text = vim.fn.getline(line)
--       local quote_col = string.match(line_text, [['"`]])
--       print("quote_col", quote_col, "line", line, "col", col)
--       -- print("line_text", line_text)
--       -- print("line", line, "col", col)
--       if quote_col ~= -1 then
--         vim.fn.setpos(".", { 0, line, quote_col + 1, 0 })
--         vim.cmd([["+normal ci"]])
--         found = true
--         break
--       end
--       line = line - 1
--     end
--     -- replace ' with ", " with `, and ` with ' on the found line
--     if found then
--       local line_text = vim.fn.getline(".")
--       -- save the quote type
--       quote_type = string.find(line_text, [['"`]])
--       local new_text = string.gsub(line_text, [['"`]], {
--         ["'"] = [["]],
--         ['"'] = [[`]],
--         ["`"] = [[']],
--       })
--       -- print("new_text", new_text)
--       vim.fn.setline(".", new_text)
--     end
--
--     -- look for nearest quote of same type after, iterate lines until match found
--     -- local end_line = vim.fn.line(".")
--     -- local end_col = vim.fn.col(".")
--     -- local end_found = false
--     -- while end_line < vim.fn.line("$") do
--     --   local line_text = vim.fn.getline(end_line)
--     --   local quote_col = vim.fn.match(line_text, quote_type, end_col)
--     --   if quote_col ~= -1 then
--     --     vim.fn.setpos(".", { 0, end_line, quote_col + 1, 0 })
--     --     vim.cmd([["+normal ci"]])
--     --     end_found = true
--     --     break
--     --   end
--     --   end_line = end_line + 1
--     -- end
--     -- replace ' with ", " with `, and ` with ' on the found line
--     -- if end_found and end_line ~= orig_line then
--     --   local line_text = vim.fn.getline(".")
--     --   local new_text = string.gsub(line_text, [['"`]], {
--     --     ["'"] = [["]],
--     --     ['"'] = [[`]],
--     --     ["`"] = [[']],
--     --   })
--     --   vim.fn.setline(".", new_text)
--     -- end
--
--     -- return to original position
--     vim.fn.setpos(".", orig_pos)
--     -- print("switched quote types")
--   end,
--   { desc = "Switch between quote types" })


-- comment line
vim.keymap.set("n", "<leader>/", ":CommentToggle<CR>", { desc = "Comment line" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete selection to void register" })

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

-- who needs Q
vim.keymap.set("n", "Q", "<nop>", { desc = "No Q" })

-- file formatting
-- TODO: move to lsp.lua?
vim.keymap.set("n", "<leader>f", function()
  -- print(vim.bo.filetype)
  if vim.bo.filetype == "dart" then
    vim.cmd("silent !dart format --line-length 120 %:p")
  else
    vim.lsp.buf.format()
  end
end, { desc = "Format file" })

vim.keymap.set("n", "<leader>nh", "<cmd>belowright new<CR>", { desc = "New buffer below" })
vim.keymap.set("n", "<leader>nH", "<cmd>aboveleft new<CR>", { desc = "New buffer above" })
vim.keymap.set("n", "<leader>nV", "<cmd>vnew<CR>", { desc = "New buffer left" })
vim.keymap.set("n", "<leader>nv", "<cmd>belowright vnew<CR>", { desc = "New buffer right" })

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list" })

-- search and replace current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Search and replace current word" })
-- search and replace current selection
vim.keymap.set("v", "<leader>s", [["hy:%s/<C-r>h/<C-r>h/gI<Left><Left><Left>]],
  { desc = "Search and replace current selection" })

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })
vim.keymap.set("n", "<leader>X", "<cmd>!chmod -x %<CR>", { silent = true, desc = "Make file not executable" })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/.config/nvim/lua/casraf/packer.lua<CR>",
  { desc = "Edit packer config" });
vim.keymap.set("n", "<leader>vpr", "<cmd>e ~/.dotfiles/.config/nvim/lua/casraf/remap.lua<CR>",
  { desc = "Edit remaps" });
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
