local function add_separator()
  local commentstr = vim.bo.commentstring
  local cmd = "normal! o<Esc>80i=<Esc>I" .. commentstr .. "<Esc>"
  local escaped = vim.api.nvim_replace_termcodes(cmd, true, false, true)
  print("commentstr %s, cmd %s, escaped %s", commentstr, cmd, escaped)
  vim.cmd(escaped)
end

local function add_separator_section()
  add_separator()
  vim.cmd("normal! o")
  add_separator()
  vim.cmd("normal! O")
end

vim.keymap.set("n", "<leader>=", add_separator, { desc = "Insert separator" })
vim.keymap.set("n", "<leader>+", add_separator_section, { desc = "Insert separator section" })

return {}
