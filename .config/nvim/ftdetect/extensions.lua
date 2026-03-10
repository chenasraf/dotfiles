vim.filetype.add({
  extension = {
    arb = "json",
    md = "markdown",
    mdx = "markdown",
    tmux = "tmux",
  },
  filename = {
    Brewfile = "ruby",
    Podfile = "ruby",
    Appfile = "ruby",
    Fastfile = "ruby",
    Tiltfile = "python",
    Makefile = function()
      vim.bo.filetype = "make"
      vim.bo.expandtab = false
      vim.bo.shiftwidth = 4
      vim.bo.softtabstop = 0
    end,
  },
  pattern = {
    [".*/ghostty/config"] = "toml",
  },
})
