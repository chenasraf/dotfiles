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
    local oil = require("oil")
    oil.setup(opts)

    local root_markers = {
      ".git",
      "package.json",
      "pubspec.yaml",
      "Cargo.toml",
      "go.mod",
      "pyproject.toml",
      "Makefile",
    }

    local function project_root()
      -- In an oil buffer the file path is an oil:// URL, so ask oil where it is
      local start = oil.get_current_dir() or vim.fn.expand("%:p:h")
      if start == nil or start == "" then
        start = vim.fn.getcwd()
      end
      return vim.fs.root(start, root_markers) or vim.fn.getcwd()
    end

    vim.keymap.set("n", "-", ":Oil<CR>", { desc = "[Oil] Back to parent dir", silent = true })
    vim.keymap.set("n", "<leader>-", function()
      oil.open(project_root())
    end, { desc = "[Oil] Project root" })
  end,
}
