# .dotfiles

These are my personal dotfiles.

Some notable tools I use are:

- Nvim (`.config/nvim`)
- Tmux (`.config/.tmux.conf`, `utils/tx`)
- WezTerm (`.config/wezterm/wezterm.lua`)
- Zplug (`zplug.init.sh`)

## Nvim Plugins

I have many many plugins and configurations going on.

Started from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and heavily modified.

Plugins are installed and configured in `.config/nvim` and its subdirectory `lua/plugins`.

Some (but not all) of the plugins/modifications are listed here:

| File                 | Related plugins                                                                                                                                                        | Description                                                                                             |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| `autoformat.lua`     | [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                                                                                                      | Code auto formatting                                                                                    |
| `barbar.lua`         | [omgrk/barbar.nvim](https://github.com/omgrk/barbar.nvim)                                                                                                              | Tabs                                                                                                    |
| `colorscheme.lua`    |                                                                                                                                                                        | Color scheme switcher                                                                                   |
| `copilot.lua`        | [zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua)                                                                                                    | Copilot (CMP)                                                                                           |
| `dadbod.lua`         | [tpope/vim-dadbod](https://github.com/tpope/vim-dadbod)                                                                                                                | Dadbod - Database manager for nvim                                                                      |
| `debug.lua`          | [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)                                                                                                      | Debugger-related code, most of these are not maintained/tested                                          |
| `floating-input.lua` | [liangxianzhe/floating-input.nvim](https://github.com/liangxianzhe/floating-input.nvim)                                                                                | Floating input                                                                                          |
| `fugitive.lua`       | [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)                                                                                                            | Git manager - I use LazyGit now, but this remain mostly for git blame functionality                     |
| `lazygit.lua`        | [kdheepak/lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)                                                                                                      | LazyGit inside nvim                                                                                     |
| `llm.lua`            | [Exafunction/codeium.nvim](https://github.com/Exafunction/codeium.nvim), [jackMort/ChatGPT.nvim](https://github.com/jackMort/ChatGPT.nvim)                             | LLM - ChatGPT/Codeium                                                                                   |
| `lsp.lua`            | [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim), [akinsho/flutter-tools.nvim](https://github.com/akinsho/flutter-tools.nvim) | LSP related configs                                                                                     |
| `matchup.lua`        | [andymass/vim-matchup](https://github.com/andymass/vim-matchup)                                                                                                        | Enables moving between function start/end as you would between brackets using `%`                       |
| `media_files.lua`    | [nvim-telescope/telescope-media-files.nvim](https://github.com/nvim-telescope/telescope-media-files.nvim)                                                              | Telescope plugin to show media file previews                                                            |
| `noice.lua`          | [folke/noice.nvim](https://github.com/folke/noice.nvim)                                                                                                                | Notifications & UI improvements                                                                         |
| `nvim-test.lua`      | [klen/nvim-test](https://github.com/klen/nvim-test)                                                                                                                    | Run tests for any project type inside nvim                                                              |
| `oil.lua`            | [stevearc/oil.nvim](https://github.com/stevearc/oil.nvim)                                                                                                              | Better than netrw. Fight me. (Lets you move between and edit directories as you would a normal file)    |
| `prettier.lua`       | [MunifTanjim/prettier.nvim](https://github.com/MunifTanjim/prettier.nvim)                                                                                              | Implements prettier code formatter into lua                                                             |
| `project_runner.lua` |                                                                                                                                                                        | Run prepared terminal commands per filetype - e.g. package.json scripts from ts/js files (Not a plugin) |
| `quicklist.lua`      |                                                                                                                                                                        | Delete/add to vim quicklist                                                                             |
| `quotes.lua`         |                                                                                                                                                                        | Allows you to toggle between `\``, `"`and`'` quotes around the cursor                                   |
| `remap.lua`          |                                                                                                                                                                        | General vim remaps not related to specific plugins                                                      |
| `schemastore.lua`    | [b0o/schemastore.nvim](https://github.com/b0o/schemastore.nvim)                                                                                                        | Auto-loads JSON `$schema` depending on filetype and name                                                |
| `sort.lua`           | [sQVe/sort.nvim](https://github.com/sQVe/sort.nvim)                                                                                                                    | Sort selected lines                                                                                     |
| `statusline.lua`     | [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                                                                                              | Status line UI updates                                                                                  |
| `surround.lua`       | [kylechui/nvim-surround](https://github.com/kylechui/nvim-surround)                                                                                                    | Surround any text with anything like brackets, quotes, HTML tags or custom strings                      |
| `telescope.lua`      | [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)                                                                                      | Fuzzy finder, preview and picker for files/commands/custom                                              |
| `text-transform.lua` | [chenasraf/text-transform.nvim](https://github.com/chenasraf/text-transform.nvim)                                                                                      | Transform between PascalCase, snake_case, camelCase, CONST_CASE and more                                |
| `theme.lua`          | [navarasu/onedark.nvim](https://github.com/navarasu/onedark.nvim)                                                                                                      | Theme configuration (OneDark)                                                                           |
| `todo_comments.lua`  | [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim)                                                                                                | Highlight & find TODO/HACK/FIXME/etc in comments across the project                                     |
| `treesitter.lua`     | [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)                                                                                  | Syntax highlighting on steroids                                                                         |
| `trouble.lua`        | [folke/trouble.nvim](https://github.com/folke/trouble.nvim)                                                                                                            | View list of diagnostics, quick fixes, TODOs, etc                                                       |
| `undotree.lua`       | [mbbill/undotree](https://github.com/mbbill/undotree)                                                                                                                  | Undo each file as you would a git branch!                                                               |
| `visual-multi.lua`   | [mg979/vim-visual-multi](https://github.com/mg979/vim-visual-multi)                                                                                                    | Multiple cursor support for nvim                                                                        |

## How to install

1. Install zsh
2. Clone this repository into `~/.dotfiles`:

   ```bash
   git clone git@github.com:chenasraf/dotfiles.git ~/.dotfiles
   ```

3. Replace entire contents of `~/.zshrc` to the new version using (`ln -s` does **not** work):

   ```bash
   echo 'source "$HOME/.dotfiles/.zshrc"' > ~/.zshrc
   ```

4. Run install scripts:

   ```bash
   source ~/.dotfiles/install.sh
   ```

   And reload the terminal
