return {
  "klen/nvim-test",
  init = function()
    -- nvim-treesitter `main` branch removed `ts_utils`. nvim-test requires it at
    -- load time for TestNearest node lookup. Provide a minimal shim so the
    -- plugin loads; TestNearest uses get_node_at_cursor + get_node_text.
    package.preload['nvim-treesitter.ts_utils'] = function()
      return {
        get_node_at_cursor = function(winnr)
          winnr = winnr or 0
          local ok, node = pcall(vim.treesitter.get_node, { winnr = winnr })
          if ok then return node end
          return nil
        end,
        get_node_text = function(node, source)
          if not node then return {} end
          local ok, text = pcall(vim.treesitter.get_node_text, node, source or 0)
          if not ok or not text then return {} end
          return vim.split(text, '\n', { plain = true })
        end,
      }
    end
  end,
  opts = {
    termOpts = {
      width = 100,
      go_back = true,
    },
    runners = {
      javascript = 'casraf.lib.nvim_test_js',
      javascriptreact = 'casraf.lib.nvim_test_js',
      typescript = 'casraf.lib.nvim_test_js',
      typescriptreact = 'casraf.lib.nvim_test_js',
      oil = 'casraf.lib.nvim_test_js',
    },
  },
  keys = {
    { "<leader>tt", "<cmd>TestFile<cr>",    desc = "[T]est Current [F]ile" },
    { "<leader>tn", "<cmd>TestNearest<cr>", desc = "[T]est [N]earest" },
    { "<leader>ts", "<cmd>TestSuite<cr>",   desc = "[T]est [S]uite" },
    { "<leader>tl", "<cmd>TestLast<cr>",    desc = "[T]est [L]ast" },
    { "<leader>tf", "<cmd>TestVisit<cr>",   desc = "[T]est [V]isit Last Run" },
    { "<leader>te", "<cmd>TestEdit<cr>",    desc = "[T]est [E]dit File" },
  },

  --[[ require('nvim-test.runners.dart'):setup({
    command = "dart",
    args = { "test" },
    file_pattern = "test/.*_test.dart$",
    find_files = { "{name}_test.dart", "test/{name}_test.dart" },
  }) ]]
}
