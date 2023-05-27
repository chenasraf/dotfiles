-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

vim.cmd('command! Ps :PackerSync')

return require('packer').startup(function(use)
  -- Packer can manage itself
  use('wbthomason/packer.nvim')

  use({
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  })

  require('telescope').setup({
    pickers = {
      find_files = {
        find_command = { 'rg', '--files', '--hidden', '-g', '!.git', '-g', '!node_modules' },
      },
    },
    defaults = {
      file_ignore_patterns = {
        "node_modules"
      },
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--hidden',
        '-g', '!.git',
        '-g', '!node_modules'
      },
    },
    extensions = {
      media_files = {
        filetypes = { "png", "webp", "jpg", "jpeg", "svg", "gif", "mp4", "webm", "pdf" },
        -- find command (defaults to `fd`)
        find_cmd = "rg"
      }
    }
  })

  -- use({ 'rose-pine/neovim', as = 'rose-pine' })
  -- require('rose-pine').setup({
  --   --- @usage 'auto'|'main'|'moon'|'dawn'
  --   variant = 'moon'
  -- })
  -- vim.cmd('colorscheme rose-pine')
  use('folke/tokyonight.nvim')
  vim.cmd('colorscheme tokyonight-storm')

  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
  use('nvim-treesitter/playground')
  use('nvim-lua/plenary.nvim')
  use('ThePrimeagen/harpoon')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')

  use('neovim/nvim-lsp')

  use({
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      { 'neovim/nvim-lsp' },
      {
        -- Optional
        'williamboman/mason.nvim',
        run = function()
          -- pcall(vim.cmd, 'MasonUpdate')
          vim.cmd('MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },     -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'L3MON4D3/LuaSnip' },     -- Required
    }
  })

  use({
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      -- require("todo-comments").setup {
      --   -- your configuration comes here
      --   -- or leave it empty to use the default settings
      --   -- refer to the configuration https://github.com/folke/todo-comments.nvim
      -- }
    end
  })

  use({
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  })

  -- use('eandrju/cellular-automaton.nvim')

  use({ 'romgrk/barbar.nvim', requires = 'nvim-tree/nvim-web-devicons' })

  use('neovim/nvim-lspconfig')
  use('jose-elias-alvarez/null-ls.nvim')
  use('MunifTanjim/prettier.nvim')

  -- use('neoclide/coc.nvim', { branch = 'release' })

  use('mfussenegger/nvim-dap')
  use('github/copilot.vim')
  use('nvim-tree/nvim-tree.lua')

  use("terrortylor/nvim-comment")

  use('nvim-lua/popup.nvim')
  use('nvim-telescope/telescope-media-files.nvim')
  use('karb94/neoscroll.nvim')

  use({
    'akinsho/flutter-tools.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
  })
  use({ 'chenasraf/text-transform.nvim', branch = "develop" })
  require('text-transform').setup({
    debug = true
  })
  use({ 'sQVe/sort.nvim' })
  require("sort").setup({})
  require('packer').startup(function()
    use {
      'stevearc/oil.nvim',
      config = function() require('oil').setup() end
    }
  end)
end)
