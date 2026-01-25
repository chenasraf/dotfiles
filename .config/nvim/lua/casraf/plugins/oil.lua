return {
  'stevearc/oil.nvim',
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      -- Remap defaults that conflict with tmux navigation
      ["<C-h>"] = false, -- was toggle hidden
      ["<C-l>"] = false, -- was refresh
      ["g."] = "actions.toggle_hidden",
      ["<C-r>"] = "actions.refresh",
    },
  },
  config = function(_, opts)
    require("oil").setup(opts)
    vim.keymap.set("n", "-", ":Oil<CR>", { desc = "[Oil] Back to parent dir", silent = true })
  end,
}
