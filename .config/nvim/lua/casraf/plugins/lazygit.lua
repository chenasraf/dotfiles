local custom = false
if custom then
  local lazygit = require('casraf.lib.lazygit')
  lazygit.setup({})
end

vim.keymap.set('n', '<leader>gs', '<Cmd>LazyGit<CR>', { desc = 'Lazy[G]it', silent = true })

return {
  {
    "chenasraf/lazygit.nvim",
    branch = "feat/resize",
    enabled = not custom,

    -- dir = home .. "/Dev/lazygit.nvim",

    -- "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
