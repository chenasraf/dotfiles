-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

vim.cmd('command! Ps :PackerSync')

return require('packer').startup(function(use)
  -- Packer can manage itself
  use('wbthomason/packer.nvim')

  use({ 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } })

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

  -- use('folke/tokyonight.nvim')
  -- vim.cmd('colorscheme tokyonight-storm')
  use({ "catppuccin/nvim", as = "catppuccin" })
  require("catppuccin").setup({
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      telescope = true,
      notify = false,
      mini = false,
      harpoon = true,
      barbar = true,
      mason = true,
    },
    dim_inactive = {
      enabled = true,
    },
  })
  vim.cmd('colorscheme catppuccin-mocha')

  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
  use('nvim-treesitter/playground')
  use('nvim-lua/plenary.nvim')
  use('dormunis/harpoon')
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

  use({ "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" })

  use({ "folke/trouble.nvim", requires = "nvim-tree/nvim-web-devicons" })
  require("trouble").setup({})

  use({ 'romgrk/barbar.nvim', requires = 'nvim-tree/nvim-web-devicons' })

  use('neovim/nvim-lspconfig')
  use('jose-elias-alvarez/null-ls.nvim')
  use('MunifTanjim/prettier.nvim')

  use('mfussenegger/nvim-dap')
  use('github/copilot.vim')
  use('nvim-tree/nvim-tree.lua')

  use('terrortylor/nvim-comment')

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
  require('text-transform').setup({ debug = true })

  use({ 'sQVe/sort.nvim' })
  require("sort").setup({})

  use({ 'stevearc/oil.nvim' })
  require('oil').setup()

  use({ 'mg979/vim-visual-multi', branch = 'master' })

  use('Shatur/neovim-session-manager')

  use('feline-nvim/feline.nvim')
  require('feline').setup()

  use({ 'kylechui/nvim-surround', branch = "main" })
  require('nvim-surround').setup({})

  use('windwp/nvim-autopairs')
  require('nvim-autopairs').setup({
    enable_check_bracket_line = false
  })

  use('windwp/nvim-ts-autotag')

  -- use('nathom/filetype.nvim')
end)
