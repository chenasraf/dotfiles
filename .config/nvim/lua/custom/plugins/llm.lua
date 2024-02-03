local keymap = {
  ['<leader>cc'] = {
    name = "CopilotChat",
    c = {
      function()
        local input = vim.fn.input("Ask Copilot: ")
        if input ~= "" then
          vim.cmd("CopilotChat " .. input)
        end
      end,
      "Chat",
      mode = { "x" },
    },
    e = { "<cmd>CopilotChatInPlace<CR>", "Edit with instruction", mode = { "n", "v" } },
    t = { "<cmd>CopilotChatTests<CR>", "Generate tests", mode = { "n", "v" } },
    v = { "<cmd>CopilotChatVisual<CR>", "Open in vertical split", mode = "x" },
    a = { "<cmd>CopilotChatAutocmd<CR>", "Autocmd", mode = { "n", "v" } },
    m = { "<cmd>CopilotChatMapping<CR>", "Map", mode = { "n", "v" } },
    x = { "<cmd>CopilotChatExplain<CR>", "Explain code", mode = { "n", "v" } },
    r = { "<cmd>CopilotChatReview<CR>", "Review", mode = { "n", "v" } },
    f = { "<cmd>CopilotChatRefactor<CR>", "Refactor", mode = { "n", "v" } },
  }
}
local keys = {}
for key, tbl in pairs(keymap["<leader>cc"]) do
  if type(tbl) == "table" and key ~= 'c' then
    local cmd = tbl[1]
    local desc = tbl[2]
    local mode = tbl.mode
    local out = {
      "<leader>cc" .. key,
      cmd,
      desc = '[CopilotChat] ' .. desc,
      mode = mode,
    }
    -- print(key, vim.inspect(out))
    table.insert(keys, out)
  end
end

return {
  {
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
  },
  -- NOTE:
  -- on new machine, run:
  -- pip3 install python-dotenv requests pynvim==0.5.0 prompt-toolkit tiktoken
  {
    "jellydn/CopilotChat.nvim",
    dependencies = { "zbirenbaum/copilot.lua" }, -- Or { "github/copilot.vim" }
    opts = {
      show_help = "yes",                         -- Show help text for CopilotChatInPlace, default: yes
      debug = true,                              -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
      prompts = {
        Explain = "Explain how it works.",
        Review = "Review the following code and provide concise suggestions.",
        Tests = "Briefly explain how the selected code works, then generate unit tests.",
        Refactor = "Refactor the code to improve clarity and readability.",
      },
    },
    build = function()
      vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
    end,
    config = function()
      require('CopilotChat').setup({
        show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
        debug = false,     -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
        prompts = {
          Explain = "Explain how the selected code works, provide any documetation references or links.",
          Review = "Review the following code and provide concise suggestions.",
          Tests = "Briefly explain how the selected code works, then generate unit tests.",
          Refactor = "Refactor the code to improve clarity and readability.",
        },
      })
      require('which-key').register(keymap)
    end,
    event = "VeryLazy",
    keys = keys,
  },
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
        ['<leader>cC'] = {
          name = "ChatGPT",
          c = { "<cmd>ChatGPT<CR>", "Chat" },
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
