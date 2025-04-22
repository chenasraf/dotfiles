return {
  "nvim-lua/plenary.nvim",
  config = function()
    require("casraf.lib.doc_search").setup({
      keymap = "<leader>dd",
      doc_sources = {
        javascript = {
          { name = "MDN", url = "https://developer.mozilla.org/en-US/search?q={query}" },
        },
        javascriptreact = {
          { name = "MDN",   url = "https://developer.mozilla.org/en-US/search?q={query}" },
          { name = "React", url = "https://reactjs.org/search?q={query}" },
        },
        typescript = {
          { name = "MDN", url = "https://developer.mozilla.org/en-US/search?q={query}" },
        },
        typescriptreact = {
          { name = "MDN",   url = "https://developer.mozilla.org/en-US/search?q={query}" },
          { name = "React", url = "https://reactjs.org/search?q={query}" },
        },
        dart = {
          { name = "Dart", url = "https://dart.dev/search?q={query}" },
        },
        css = {
          { name = "MDN", url = "https://developer.mozilla.org/en-US/search?q={query}" },
        },
      },
    })
  end,
}
