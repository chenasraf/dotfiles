return {
  -- "chenasraf/lazygit.nvim",
  -- dir = "/Users/Dev/lazygit.nvim",

  -- branch = "feat/resize",
  "kdheepak/lazygit.nvim",
  -- optional for floating window border decoration
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    vim.keymap.set('n', '<leader>gs', '<Cmd>LazyGit<CR>', { desc = 'Lazy[G]it', silent = true })
  end,
}
