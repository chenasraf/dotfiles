-- local lazygit = require('casraf.lib.lazygit')
--
-- lazygit.setup({})

return {
  {
    "chenasraf/lazygit.nvim",
    branch = "feat/resize",
    -- enabled = false,

    -- dir = home .. "/Dev/lazygit.nvim",

    -- "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.keymap.set('n', '<leader>gs', '<Cmd>LazyGit<CR>', { desc = 'Lazy[G]it', silent = true })
    end,
  },
}
