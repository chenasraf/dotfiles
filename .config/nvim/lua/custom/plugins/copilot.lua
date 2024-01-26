return {
  "zbirenbaum/copilot.lua",
  dependencies = {
    "zbirenbaum/copilot-cmp",
  },
  config = function()
    -- See https://github.com/zbirenbaum/copilot.lua
    require("copilot_cmp").setup({
      filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        gitcommit = true,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
    })
    require("copilot").setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
    })
  end,
}
