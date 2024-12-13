-- local home = os.getenv('HOME')
return {
  "chenasraf/lazygit.nvim",
  branch = "feat/resize",

  -- dir = home .. "/Dev/lazygit.nvim",

  -- "kdheepak/lazygit.nvim",
  -- optional for floating window border decoration
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    vim.keymap.set('n', '<leader>gs', '<Cmd>LazyGit<CR>', { desc = 'Lazy[G]it', silent = true })
  end,
}
