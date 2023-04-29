vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

vim.keymap.set("n", "<leader>tD", function()
  vim.cmd(":TodoTelescope")
end, { desc = "All Todos" })

vim.keymap.set("n", "<leader>td", function()
  vim.cmd(":TodoTrouble")
end, { desc = "Toggle todo pane" })

