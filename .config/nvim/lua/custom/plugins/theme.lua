return {
  -- Theme inspired by Atom
  'navarasu/onedark.nvim',
  priority = 1000,
  config = function()
    require('onedark').setup({
      transparent = true,
      lualine = {
        transparent = true,
      },
      style = 'darker',
    })
    vim.cmd.colorscheme 'onedark'
  end,
}
