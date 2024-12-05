return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavor = "mocha",
    transparent_background = true,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
-- return {
--   -- Theme inspired by Atom
--   'navarasu/onedark.nvim',
--   priority = 1000,
--   config = function()
--     require('onedark').setup({
--       transparent = true,
--       lualine = {
--         transparent = true,
--       },
--       style = 'darker',
--     })
--     vim.cmd.colorscheme 'onedark'
--   end,
-- }
