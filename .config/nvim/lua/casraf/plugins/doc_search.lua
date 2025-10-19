return {
  "nvim-lua/plenary.nvim",
  config = function()
    local mdn = { name = "MDN", url = "https://developer.mozilla.org/en-US/search?q={query}" }
    local react = { name = "React", url = "https://reactjs.org/search?q={query}" }
    local npm = { name = "NPM", url = "https://www.npmjs.com/search?q={query}" }
    local dart = { name = "Dart", url = "https://dart.dev/search?q={query}" }
    local pub = { name = "Pub.dev", url = "https://pub.dev/search?q={query}" }
    local lua = { name = "Lua", url = "https://www.lua.org/search.html?q={query}" }

    require("casraf.lib.doc_search").setup({
      keymap = "<leader>dd",
      doc_sources = {
        javascript = { mdn, npm },
        javascriptreact = { mdn, react, npm },
        typescript = { mdn, npm },
        typescriptreact = { mdn, react, npm },
        dart = { dart, pub },
        css = { mdn },
        lua = { lua },
      },
    })
  end,
}
