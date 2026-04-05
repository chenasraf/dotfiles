return {
  "chenasraf/vim-matchup",
  branch = 'fix/nvim-v0.12.x',
  config = function()
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end,
}
