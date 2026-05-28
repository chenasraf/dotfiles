return {
  dir = vim.fn.stdpath("config"),
  name = "md_anchor",
  event = "VeryLazy",
  config = function()
    require("casraf.lib.md_anchor").setup()
  end,
}
