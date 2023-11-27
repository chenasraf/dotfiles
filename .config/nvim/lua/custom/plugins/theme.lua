return {
  -- Theme inspired by Atom
  'navarasu/onedark.nvim',
  config = function()
  end,
  priority = 1000,
  config = function()
    require('onedark').setup({
      transparent = true,
      lualine = {
        transparent = true,
      },
    })
    vim.cmd.colorscheme 'onedark'
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end,
}
