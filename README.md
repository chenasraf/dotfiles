# .dotfiles

These are my personal dotfiles.

![image](https://github.com/chenasraf/dotfiles/assets/167217/c19520c1-fb7e-4c6f-8181-6979979c593c)

<details><summary>Screenshots</summary>
 
![image](https://github.com/chenasraf/dotfiles/assets/167217/9caa45f3-586b-40f1-bcd5-8165bf7c1107) ![image](https://github.com/chenasraf/dotfiles/assets/167217/8fca7543-cdc1-45f9-92f0-fadf484077ba) ![image](https://github.com/chenasraf/dotfiles/assets/167217/3afaca9a-eda8-4625-b521-83e9946a099c) ![image](https://github.com/chenasraf/dotfiles/assets/167217/5dddef8e-92f9-4d67-860c-9b20c7074706)

</details>

Some notable tools I use are:

- Nvim (`.config/nvim`)
- Tmux (`.config/.tmux.conf`, `utils/tx`, `plugins/tmux.plugin.zsh`)
- WezTerm (`.config/wezterm/wezterm.lua`)
- Zplug (`zplug.init.sh`)

## Nvim Plugins

I have many many plugins and configurations going on.

Started from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and heavily modified.

Plugins are installed and configured in `.config/nvim` and its subdirectory `lua/plugins`.

Some (but not all) of the plugins/modifications are listed here:

| File                 | Description                                                                                             | Related plugins                                                                                                                                                        |
| -------------------- | ------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `autoformat.lua`     | Code auto formatting                                                                                    | [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                                                                                                      |
| `barbar.lua`         | Tabs                                                                                                    | [omgrk/barbar.nvim](https://github.com/omgrk/barbar.nvim)                                                                                                              |
| `colorscheme.lua`    | Color scheme switcher                                                                                   |                                                                                                                                                                        |
| `copilot.lua`        | Copilot (CMP)                                                                                           | [zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua)                                                                                                    |
| `dadbod.lua`         | Dadbod - Database manager for nvim                                                                      | [tpope/vim-dadbod](https://github.com/tpope/vim-dadbod)                                                                                                                |
| `debug.lua`          | Debugger-related code, most of these are not maintained/tested                                          | [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)                                                                                                      |
| `floating-input.lua` | Floating input                                                                                          | [liangxianzhe/floating-input.nvim](https://github.com/liangxianzhe/floating-input.nvim)                                                                                |
| `fugitive.lua`       | Git manager - I use LazyGit now, but this remain mostly for git blame functionality                     | [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)                                                                                                            |
| `lazygit.lua`        | LazyGit inside nvim                                                                                     | [kdheepak/lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)                                                                                                      |
| `llm.lua`            | LLM - ChatGPT/Codeium                                                                                   | [Exafunction/codeium.nvim](https://github.com/Exafunction/codeium.nvim), [jackMort/ChatGPT.nvim](https://github.com/jackMort/ChatGPT.nvim)                             |
| `lsp.lua`            | LSP related configs                                                                                     | [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim), [akinsho/flutter-tools.nvim](https://github.com/akinsho/flutter-tools.nvim) |
| `matchup.lua`        | Enables moving between function start/end as you would between brackets using `%`                       | [andymass/vim-matchup](https://github.com/andymass/vim-matchup)                                                                                                        |
| `media_files.lua`    | Telescope plugin to show media file previews                                                            | [nvim-telescope/telescope-media-files.nvim](https://github.com/nvim-telescope/telescope-media-files.nvim)                                                              |
| `noice.lua`          | Notifications & UI improvements                                                                         | [folke/noice.nvim](https://github.com/folke/noice.nvim)                                                                                                                |
| `nvim-test.lua`      | Run tests for any project type inside nvim                                                              | [klen/nvim-test](https://github.com/klen/nvim-test)                                                                                                                    |
| `oil.lua`            | Better than netrw. Fight me. (Lets you move between and edit directories as you would a normal file)    | [stevearc/oil.nvim](https://github.com/stevearc/oil.nvim)                                                                                                              |
| `prettier.lua`       | Implements prettier code formatter into lua                                                             | [MunifTanjim/prettier.nvim](https://github.com/MunifTanjim/prettier.nvim)                                                                                              |
| `project_runner.lua` | Run prepared terminal commands per filetype - e.g. package.json scripts from ts/js files (Not a plugin) |                                                                                                                                                                        |
| `quicklist.lua`      | Delete/add to vim quicklist                                                                             |                                                                                                                                                                        |
| `quotes.lua`         | Allows you to toggle between `\``, `"`and`'` quotes around the cursor                                   |                                                                                                                                                                        |
| `remap.lua`          | General vim remaps not related to specific plugins                                                      |                                                                                                                                                                        |
| `schemastore.lua`    | Auto-loads JSON `$schema` depending on filetype and name                                                | [b0o/schemastore.nvim](https://github.com/b0o/schemastore.nvim)                                                                                                        |
| `sort.lua`           | Sort selected lines                                                                                     | [sQVe/sort.nvim](https://github.com/sQVe/sort.nvim)                                                                                                                    |
| `statusline.lua`     | Status line UI updates                                                                                  | [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                                                                                              |
| `surround.lua`       | Surround any text with anything like brackets, quotes, HTML tags or custom strings                      | [kylechui/nvim-surround](https://github.com/kylechui/nvim-surround)                                                                                                    |
| `telescope.lua`      | Fuzzy finder, preview and picker for files/commands/custom                                              | [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)                                                                                      |
| `text-transform.lua` | Transform between PascalCase, snake_case, camelCase, CONST_CASE and more                                | [chenasraf/text-transform.nvim](https://github.com/chenasraf/text-transform.nvim)                                                                                      |
| `theme.lua`          | Theme configuration (OneDark)                                                                           | [navarasu/onedark.nvim](https://github.com/navarasu/onedark.nvim)                                                                                                      |
| `todo_comments.lua`  | Highlight & find TODO/HACK/FIXME/etc in comments across the project                                     | [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim)                                                                                                |
| `treesitter.lua`     | Syntax highlighting on steroids                                                                         | [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)                                                                                  |
| `trouble.lua`        | View list of diagnostics, quick fixes, TODOs, etc                                                       | [folke/trouble.nvim](https://github.com/folke/trouble.nvim)                                                                                                            |
| `undotree.lua`       | Undo each file as you would a git branch!                                                               | [mbbill/undotree](https://github.com/mbbill/undotree)                                                                                                                  |
| `visual-multi.lua`   | Multiple cursor support for nvim                                                                        | [mg979/vim-visual-multi](https://github.com/mg979/vim-visual-multi)                                                                                                    |

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

## My Other Stuff

See some of my other projects at [my website](https://casraf.dev/projects).

Or some of my packages:

NPM:

- [Simple Scaffold](https://npmjs.com/package/simple-scaffold)
- [Massarg](https://npmjs.com/package/massarg)

Dart:

- [Script Runner](https://pub.dev/packages/script_runner)
- [Unaconfig](https://pub.dev/packages/unaconfig)
