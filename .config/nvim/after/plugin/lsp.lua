local lsp = require('lsp-zero').preset("recommended")
local lspconfig = require('lspconfig')

lsp.ensure_installed({
  -- 'lua-language-server',
  'tsserver',
  'eslint',
  'rust_analyzer'
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  -- TODO: either change this or change the mapping for tmux
  ["<C-Space>"] = cmp.mapping.complete(),
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
  suggest_lsp_servers = true,
  sign_icons = {
    error = '⛔',
    warn = '⚠',
    hint = '💡',
    info = 'ℹ',
  }
})

---@diagnostic disable-next-line: unused-local
lsp.on_attach(function(client, bufnr)
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, {
    desc = "Go to definition",
    buffer = bufnr,
    remap = false
  })
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, {
    desc = "Hover",
    buffer = bufnr,
    remap = false
  })
  vim.keymap.set("n", "gws", function() vim.lsp.buf.workspace_symbol() end, {
    desc = "Workspace symbol",
    buffer = bufnr,
    remap = false
  })
  vim.keymap.set("n", "gD", function() vim.diagnostic.open_float() end, {
    desc = "Open diagnostics",
    buffer = bufnr,
    remap = false
  })
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, {
    desc = "Go to next diagnostic",
    buffer = bufnr,
    remap = false
  })
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, {
    desc = "Go to previous diagnostic",
    buffer = bufnr,
    remap = false
  })
  vim.keymap.set({ "n", "v" }, "ga", function() vim.lsp.buf.code_action() end,
    {
      desc = "Code action",
      buffer = bufnr,
      remap = false
    })
  vim.keymap.set("n", "grr", function() vim.lsp.buf.references() end,
    {
      desc = "References",
      buffer = bufnr,
      remap = false
    })
  vim.keymap.set("n", "grn", function() vim.lsp.buf.rename() end, {
    desc = "Rename symbol",
    buffer = bufnr,
    remap = false
  })
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, {
    desc = "Signature help",
    buffer = bufnr,
    remap = false
  })
end)

lspconfig.yamlls.setup({
  settings = {
    yaml = {
      keyOrdering = false
    },
    json = {
      filetypes = { "json", "jsonc", "arb" },
    }
  }
})

lspconfig.bashls.setup({
  filetypes = { "sh", "zsh" },
  settings = {
    allowlist = {
      "sh",
      "zsh"
    },
    bash = {
      filetypes = { "sh", "zsh" }
    }
  }
})

-- require('filetype').setup({
--   shebang = {
--     zsh = "sh"
--   }
-- })

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})

require("flutter-tools").setup({})
