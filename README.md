# .dotfiles

These are my personal dotfiles.

<img width="1744" height="1081" alt="image" src="https://github.com/user-attachments/assets/51f81f88-91e9-46ad-a080-4de5541927b8" />

<details><summary>Screenshots</summary>

<img width="1744" height="1081" alt="image" src="https://github.com/user-attachments/assets/48d1629e-5330-4423-9644-dbdd30884c42" />
<img width="1744" height="1081" alt="image" src="https://github.com/user-attachments/assets/8b236741-74f7-42b6-b2a9-ed39866e45f4" />
<img width="1744" height="1081" alt="image" src="https://github.com/user-attachments/assets/678d44e2-49a9-407b-a8ae-74cf4f8dfd01" />

</details>

Some notable tools I use are:

- Nvim (`.config/nvim`)
- Tmux (`.config/tmux`, `utils/tx`)
- WezTerm (`.config/wezterm/wezterm.lua`)

### Requirements

1. Node.js (PNPM will be installed)
2. jq

## Nvim Plugins

I have many many plugins and configurations going on.

Started from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and heavily modified.

Plugins are installed and configured in `.config/nvim/lua/casraf/plugins`.

Some (but not all) of the plugins/modifications are listed here:

| File                 | Description                                                                                             | Related plugins                                                                                                                                                                                                 |
| -------------------- | ------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `autoformat.lua`     | Code auto formatting                                                                                    | [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                                                                                                                                               |
| `barbar.lua`         | Tabs                                                                                                    | [romgrk/barbar.nvim](https://github.com/romgrk/barbar.nvim)                                                                                                                                                     |
| `ccc.lua`            | Color picker and highlighter                                                                            | [uga-rosa/ccc.nvim](https://github.com/uga-rosa/ccc.nvim)                                                                                                                                                       |
| `cmp.lua`            | Autocompletion with LSP, snippets, and LLM integration                                                  | [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp), [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)                                                                                                |
| `colorscheme.lua`    | Color scheme switcher                                                                                   |                                                                                                                                                                                                                 |
| `debug.lua`          | Debugger-related code, most of these are not maintained/tested                                          | [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)                                                                                                                                               |
| `doc_search.lua`     | Search documentation for different languages (MDN, React, NPM, Dart, etc.)                              |                                                                                                                                                                                                                 |
| `floating-input.lua` | Floating input                                                                                          | [liangxianzhe/floating-input.nvim](https://github.com/liangxianzhe/floating-input.nvim)                                                                                                                         |
| `format.lua`         | Code formatting with Prettier                                                                           | [MunifTanjim/prettier.nvim](https://github.com/MunifTanjim/prettier.nvim)                                                                                                                                       |
| `fugitive.lua`       | Git manager - I use LazyGit now, but this remain mostly for git blame functionality                     | [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)                                                                                                                                                     |
| `git_open.lua`       | Open git repositories, branches, commits, and files in browser                                          |                                                                                                                                                                                                                 |
| `go.lua`             | Go language support and tooling                                                                         | [ray-x/go.nvim](https://github.com/ray-x/go.nvim)                                                                                                                                                               |
| `lazygit.lua`        | LazyGit inside nvim                                                                                     | [kdheepak/lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)                                                                                                                                               |
| `license.lua`        | SPDX license header snippets                                                                            |                                                                                                                                                                                                                 |
| `llm.lua`            | LLM - Copilot, ChatGPT (requires `OPENAI_API_KEY` env), Codeium                                         | [zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua), [Exafunction/codeium.nvim](https://github.com/Exafunction/codeium.nvim), [jackMort/ChatGPT.nvim](https://github.com/jackMort/ChatGPT.nvim) |
| `lsp.lua`            | LSP related configs                                                                                     | [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim), [akinsho/flutter-tools.nvim](https://github.com/akinsho/flutter-tools.nvim)                                          |
| `matchup.lua`        | Enables moving between function start/end as you would between brackets using `%`                       | [andymass/vim-matchup](https://github.com/andymass/vim-matchup)                                                                                                                                                 |
| `noice.lua`          | Notifications & UI improvements                                                                         | [folke/noice.nvim](https://github.com/folke/noice.nvim)                                                                                                                                                         |
| `notes.lua`          | Notes management with Telescope integration                                                             |                                                                                                                                                                                                                 |
| `nvim-test.lua`      | Run tests for any project type inside nvim                                                              | [klen/nvim-test](https://github.com/klen/nvim-test)                                                                                                                                                             |
| `oil.lua`            | Better than netrw. Fight me. (Lets you move between and edit directories as you would a normal file)    | [stevearc/oil.nvim](https://github.com/stevearc/oil.nvim)                                                                                                                                                       |
| `popup-menu.lua`     | Custom right-click popup menu with LSP actions                                                          |                                                                                                                                                                                                                 |
| `project_runner.lua` | Run prepared terminal commands per filetype - e.g. package.json scripts from ts/js files (Not a plugin) |                                                                                                                                                                                                                 |
| `quicklist.lua`      | Delete/add to vim quicklist                                                                             |                                                                                                                                                                                                                 |
| `quotes.lua`         | Allows you to toggle between `\``, `"`and`'` quotes around the cursor                                   |                                                                                                                                                                                                                 |
| `remap.lua`          | General vim remaps not related to specific plugins                                                      |                                                                                                                                                                                                                 |
| `schemastore.lua`    | Auto-loads JSON `$schema` depending on filetype and name                                                | [b0o/schemastore.nvim](https://github.com/b0o/schemastore.nvim)                                                                                                                                                 |
| `separators.lua`     | Insert comment separator lines                                                                          |                                                                                                                                                                                                                 |
| `session.lua`        | Session management with auto save/restore                                                               |                                                                                                                                                                                                                 |
| `statusline.lua`     | Status line UI updates                                                                                  | [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                                                                                                                                       |
| `surround.lua`       | Surround any text with anything like brackets, quotes, HTML tags or custom strings                      | [kylechui/nvim-surround](https://github.com/kylechui/nvim-surround)                                                                                                                                             |
| `telescope.lua`      | Fuzzy finder, preview and picker for files/commands/custom                                              | [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)                                                                                                                               |
| `text-transform.lua` | Transform between PascalCase, snake_case, camelCase, CONST_CASE and more                                | [chenasraf/text-transform.nvim](https://github.com/chenasraf/text-transform.nvim)                                                                                                                               |
| `theme.lua`          | Theme configuration (OneDark)                                                                           | [navarasu/onedark.nvim](https://github.com/navarasu/onedark.nvim)                                                                                                                                               |
| `todo_comments.lua`  | Highlight & find TODO/HACK/FIXME/etc in comments across the project                                     | [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim)                                                                                                                                         |
| `treesitter.lua`     | Syntax highlighting on steroids                                                                         | [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)                                                                                                                           |
| `trouble.lua`        | View list of diagnostics, quick fixes, TODOs, etc                                                       | [folke/trouble.nvim](https://github.com/folke/trouble.nvim)                                                                                                                                                     |
| `undotree.lua`       | Undo each file as you would a git branch!                                                               | [mbbill/undotree](https://github.com/mbbill/undotree)                                                                                                                                                           |
| `uuid_gen.lua`       | UUID generation snippet                                                                                 | [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)                                                                                                                                                         |
| `visual-multi.lua`   | Multiple cursor support for nvim                                                                        | [mg979/vim-visual-multi](https://github.com/mg979/vim-visual-multi)                                                                                                                                             |

## How to install

1. Install zsh
2. Clone this repository into `~/.dotfiles`:

   ```bash
   git clone git@github.com:chenasraf/dotfiles.git --depth 1 ~/.dotfiles
   ```

3. Replace entire contents of `~/.zshrc` to the new version using (`ln -s` does **not** work):

   ```bash
   echo 'source "$HOME/.dotfiles/.zshrc"' > ~/.zshrc
   ```

4. Run install scripts:

   ```bash
   source ~/.dotfiles/install.zsh
   ```

   And reload the terminal

## My Other Stuff

See some of my other projects at [my website](https://casraf.dev/projects).

Or some of my packages:

### NPM

- [Simple Scaffold](https://chenasraf.github.io/simple-scaffold) - Generate any file structure -
  from single components to entire app boilerplates, with a single command.
- [Massarg](https://chenasraf.github.io/massarg) - Flexible, powerful, and simple command/argument
  parser for CLI applications

### Dart/Flutter

#### Apps

- [Dungeon Paper](https://github.com/DungeonPaper/dungeon-paper-app) - A Dungeon World character
  sheet app written with Flutter
- [Mudblock](https://github.com/chenasraf/mudblock) - An MUD client for mobile & desktop

#### Packages

- [Script Runner](https://pub.dev/packages/script_runner) - Run all your project-related scripts in
  a portable, simple config.
- [Unaconfig](https://pub.dev/packages/unaconfig) - Load your user's config files for your package
  easily, from multiple sources & formats. Like
  [cosmiconfig](https://www.npmjs.com/package/cosmiconfig), but for Dart!
- [CTelnet](https://pub.dev/packages/ctelnet) - A simple Telnet client for Dart/Flutter, parse
  incoming and outgoing data easily and quickly.
- [btool](https://pub.dev/packages/btool) - Generic build helper tools for Flutter/Dart such as
  manipulating version, package name or application ID
- [Wheel Spinner](https://pub.dev/packages/wheel_spinner) - A simple Flutter widget for updating a
  number using a pitch bender-like spinner

### Neovim

- [text-transform.nvim](https://github.com/chenasraf/text-transform.nvim) - Common text transformers
  for nvim - switch between camelCase, PascalCase, snake_case, and more!

## Rust

- [tblf](https://github.com/chenasraf/tblf) - Turns any CLI output lines into tables.

### Go

- [GI Gen](https://github.com/chenasraf/gi_gen) - Gitignore generator for any type of
  projectackages/unaconfig)
