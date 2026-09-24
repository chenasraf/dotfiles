-- Mason installs into stdpath('data'), which this repo does not track, so a fresh
-- machine starts with nothing. This is the single list of what to put back.
--
-- It lives here rather than split across mason-lspconfig and mason-nvim-dap because
-- each of those takes names in its own namespace (lspconfig server names, nvim-dap
-- adapter names), and a name in the wrong namespace is silently dropped rather than
-- reported. mason-tool-installer takes mason package names — the names `:Mason`
-- shows — so the list reads the same as the package directory.
return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  -- The install pass runs from a VimEnter autocmd registered when this plugin loads,
  -- so a lazy load lands after VimEnter has already fired and nothing installs.
  lazy = false,
  dependencies = {
    { 'williamboman/mason.nvim', opts = {} },
  },
  opts = {
    ensure_installed = {
      -- Language servers
      'ast-grep',
      'astro-language-server',
      'bash-language-server',
      'clangd',
      'css-lsp',
      'eslint-lsp',
      'gopls',
      'html-lsp',
      'jedi-language-server',
      'json-lsp',
      'kotlin-language-server',
      'lua-language-server',
      'phpactor',
      'rust-analyzer',
      'tailwindcss-language-server',
      'typescript-language-server',
      'vue-language-server',
      'yaml-language-server',

      -- Formatters and linters. prettier and black are deliberately absent — sofmani
      -- provisions those, and a mason copy would shadow it on $PATH.
      'ktfmt',
      'pretty-php',
      'shfmt',
      'swiftformat',
      'swiftlint',

      -- Debug adapters
      'js-debug-adapter',

      -- Build tooling
      'xcode-build-server',
    },
    run_on_start = true,
    -- Updates are a deliberate `:MasonToolsUpdate`, so a machine's toolchain doesn't
    -- shift under it on an unrelated morning.
    auto_update = false,
  },
}
