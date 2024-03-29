
return {
  "folke/todo-comments.nvim",
  config = function()
    local comments = require("todo-comments")
    comments.setup({
      highlight = {
            pattern = [[.*<(KEYWORDS)\s*]],
      },
      search = {
        pattern = [[\b(KEYWORDS)\b]]
      }
    })

    vim.keymap.set("n", "]t", function()
      comments.jump_next()
    end, { desc = "Next todo comment" })

    vim.keymap.set("n", "[t", function()
      comments.jump_prev()
    end, { desc = "Previous todo comment" })

    vim.keymap.set("n", "<leader>tD", function()
      vim.cmd(":TodoTelescope")
    end, { desc = "All Todos" })

    vim.keymap.set("n", "<leader>td", function()
      vim.cmd(":TodoTrouble")
    end, { desc = "Toggle todo pane" })
  end,
}
