return {
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({})
    end
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        api_key_cmd = os.getenv("OPENAI_API_KEY"),
      })
      require('which-key').register {
        ['<leader>c'] = {
          name = "ChatGPT",
          c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
          e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
          g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
          t = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
          k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
          d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
          a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
          o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
          s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
          f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
          x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
          r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
          l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
        }
      }

      -- -- telescope selector with all commands
      -- local function telescope_selector()
      --   local cmd_list = {
      --     "ChatGPT",
      --     "ChatGPTRun",
      --     "ChatGPTActAs",
      --     "ChatGPTEditWithInstruction",
      --   }
      --   local actions = require('telescope.actions')
      --   local action_state = require('telescope.actions.state')
      --   local finders = require('telescope.finders')
      --   local pickers = require('telescope.pickers')
      --   local sorters = require('telescope.sorters')
      --
      --   pickers.new({}, {
      --     prompt_title = 'ChatGPT',
      --     finder = finders.new_table(cmd_list),
      --     sorter = sorters.get_generic_fuzzy_sorter(),
      --     attach_mappings = function(bufnr, map)
      --       actions.select_default:replace(function()
      --         local selection = action_state.get_selected_entry()
      --         print('selection', selection)
      --         actions.close(bufnr)
      --         vim.cmd(selection.value)
      --       end)
      --       return true
      --     end,
      --   }):find()
      -- end
      --
      -- vim.keymap.set("n", "<leader>cc", telescope_selector, { desc = "ChatGPT" })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim"
    }
  }
}
