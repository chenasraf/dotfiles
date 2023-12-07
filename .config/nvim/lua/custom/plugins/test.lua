return {
  "klen/nvim-test",
  config = function()
    require('nvim-test').setup()
    vim.keymap.set("n", "<leader>tt", "<cmd>TestFile<cr>", { noremap = true, desc = "[T]est Current [F]ile" })
    vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest<cr>", { noremap = true, desc = "[T]est [N]earest" })
    vim.keymap.set("n", "<leader>ts", "<cmd>TestSuite<cr>", { noremap = true, desc = "[T]est [S]uite" })
    vim.keymap.set("n", "<leader>tl", "<cmd>TestLast<cr>", { noremap = true, desc = "[T]est [L]ast" })
    vim.keymap.set("n", "<leader>tf", "<cmd>TestVisit<cr>", { noremap = true, desc = "[T]est [V]isit Last Run" })
    vim.keymap.set("n", "<leader>te", "<cmd>TestEdit<cr>", { noremap = true, desc = "[T]est [E]dit File" })

    --[[ require('nvim-test.runners.dart'):setup({
      command = "dart",
      args = { "test" },
      file_pattern = "test/.*_test.dart$",
      find_files = { "{name}_test.dart", "test/{name}_test.dart" },
    }) ]]
  end
}
