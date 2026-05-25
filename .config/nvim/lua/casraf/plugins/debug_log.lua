return {
  dir = vim.fn.stdpath("config"),
  name = "debug_log",
  event = "VeryLazy",
  config = function()
    require("casraf.lib.debug_log").setup()
  end,
}
