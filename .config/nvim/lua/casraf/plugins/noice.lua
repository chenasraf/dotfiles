return {
  "folke/noice.nvim",
  event = "VeryLazy",
  config = function()
    require('noice').setup({
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      views = {
        notify = {
          replace = true, -- allow Noice to replace default notify view
        },
      },
      -- you can enable a preset for easier configuration
      -- presets = {
      --   -- bottom_search = true,         -- use a classic bottom cmdline for search
      --   -- command_palette = true,       -- position the cmdline and popupmenu together
      --   long_message_to_split = true, -- long messages will be sent to a split
      --   inc_rename = false,           -- enables an input dialog for inc-rename.nvim
      --   -- lsp_doc_border = false,       -- add a border to hover docs and signature help
      -- },
    })
    require("notify").setup({
      background_colour = "#000000",
      stages = "static",
      top_down = false, -- this makes notifications stack from bottom up
    })

    vim.keymap.set("n", "<leader><leader>c", "<Cmd>NoiceDismiss<CR>", {
      silent = true, desc = '[C]lear [N]otifications'
    })
  end,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  }
}
