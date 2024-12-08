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
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- Or { "github/copilot.vim" }
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
    },
    config = function(opts)
      require('CopilotChat').setup(opts)
      require('which-key').add({
        { "<leader>cx", group = "CopilotChat" },
        {
          mode = { "n", "v", "x" },
          { "<leader>cxc", "<cmd>CopilotChat<CR>",              desc = "Chat" },
          { "<leader>cxx", "<cmd>CopilotChatExplain<CR>",       desc = "Explain code" },
          { "<leader>cxf", "<cmd>CopilotChatFix<CR>",           desc = "Fix bugs" },
          { "<leader>cxd", "<cmd>CopilotChatFixDiagnostic<CR>", desc = "Fix diagnostic issues" },
          { "<leader>cxo", "<cmd>CopilotChatOptimize<CR>",      desc = "Optimize code" },
          { "<leader>cxr", "<cmd>CopilotChatReview<CR>",        desc = "Review" },
          { "<leader>cxC", "<cmd>CopilotChatCommit<CR>",        desc = "Generate commit message" },
          { "<leader>cxt", "<cmd>CopilotChatTests<CR>",         desc = "Generate tests" },
          { "<leader>cxd", "<cmd>CopilotChatDocs<CR>",          desc = "Generate docs" },
          {
            "<leader>cxi",
            function()
              local input = vim.fn.input("Ask Copilot: ")
              if input ~= "" then
                vim.cmd("CopilotChat " .. input)
              end
            end,
            desc = "Ask",
          },
        },
      })
    end,
    event = "VeryLazy",
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
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      local API_KEY = os.getenv("OPENAI_API_KEY")
      if not API_KEY then
        print("OPENAI_API_KEY is not set")
      else
        require("chatgpt").setup({
          api_key_cmd = API_KEY,
        })
      end
      require('which-key').add({
        { "<leader>cc",  group = "ChatGPT" },
        { "<leader>ccc", "<cmd>ChatGPT<CR>", desc = "Chat", mode = "n" },
        {
          mode = { "n", "v" },
          { "<leader>cce", "<cmd>ChatGPTEditWithInstruction<CR>",           desc = "Edit with instruction" },
          { "<leader>ccg", "<cmd>ChatGPTRun grammar_correction<CR>",        desc = "Grammar Correction" },
          { "<leader>cct", "<cmd>ChatGPTRun translate<CR>",                 desc = "Translate" },
          { "<leader>cck", "<cmd>ChatGPTRun keywords<CR>",                  desc = "Keywords" },
          { "<leader>ccd", "<cmd>ChatGPTRun docstring<CR>",                 desc = "Docstring" },
          { "<leader>cca", "<cmd>ChatGPTRun add_tests<CR>",                 desc = "Add Tests" },
          { "<leader>cco", "<cmd>ChatGPTRun optimize_code<CR>",             desc = "Optimize Code" },
          { "<leader>ccs", "<cmd>ChatGPTRun summarize<CR>",                 desc = "Summarize" },
          { "<leader>ccf", "<cmd>ChatGPTRun fix_bugs<CR>",                  desc = "Fix Bugs" },
          { "<leader>ccx", "<cmd>ChatGPTRun explain_code<CR>",              desc = "Explain Code" },
          { "<leader>ccr", "<cmd>ChatGPTRun roxygen_edit<CR>",              desc = "Roxygen Edit" },
          { "<leader>ccl", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis" },
        }
      })
    end,
  }
}
