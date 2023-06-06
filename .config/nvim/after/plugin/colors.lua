function ColorMyPencils(scheme)
  scheme = scheme or "catppuccin"
  vim.cmd.colorscheme(scheme)

  -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()

