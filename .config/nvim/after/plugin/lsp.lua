local lsp = require('lsp-zero').preset("recommended")

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

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
  suggest_lsp_servers = true,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
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
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, {
    desc = "Workspace symbol",
    buffer = bufnr,
    remap = false
  })
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, {
    desc = "Open diagnostics",
    buffer = bufnr,
    remap = false
  })
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, {
    desc = "Go to next diagnostic",
    buffer = bufnr,
    remap = false
  })
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, {
    desc = "Go to previous diagnostic",
    buffer = bufnr,
    remap = false
  })
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end,
    {
      desc = "Code action",
      buffer = bufnr,
      remap = false
    })
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end,
    {
      desc = "References",
      buffer = bufnr,
      remap = false
    })
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, {
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

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})

require("flutter-tools").setup({})

-- dart

-- local nvim_lsp = require 'lspconfig'
-- local configs = require 'lspconfig/configs'
-- 
-- local server_name = "dartls"
-- local bin_name = "dart"
-- 
-- local find_dart_sdk_root_path = function()
--   if vim.fn["executable"]("dart") == 1 then
--     return vim.fn["resolve"](vim.fn["exepath"]("dart"))
--   elseif vim.fn["executable"]("flutter") == 1 then
--     local flutter_path = vim.fn["resolve"](vim.fn["exepath"]("flutter"))
--     local flutter_bin = vim.fn["fnamemodify"](flutter_path, ":h")
--     local dart_sdk_root_path = flutter_bin .. "/cache/dart-sdk/bin/dart"
--     if vim.fn["executable"](dart_sdk_root_path) == 1 then
--       return dart_sdk_root_path
--     end
--   end
--   error("[LSP] Could not find Dart SDK root path")
-- end
-- 
-- local analysis_server_snapshot_path = function()
--   local dart_sdk_root_path = vim.fn["fnamemodify"](find_dart_sdk_root_path(), ":h")
--   local snapshot = dart_sdk_root_path .. "/snapshots/analysis_server.dart.snapshot"
-- 
--   if vim.fn["has"]("win32") == 1 or vim.fn["has"]("win64") == 1 then
--     snapshot = snapshot:gsub("/", "\\")
--   end
-- 
--   if vim.fn["filereadable"](snapshot) == 1 then
--     return snapshot
--   else
--     error("[LSP] Could not find analysis server snapshot")
--   end
-- end
-- 
-- configs[server_name] = {
--   default_config = {
--     cmd = { bin_name, analysis_server_snapshot_path(), "--lsp" },
--     filetypes = { "dart" },
--     root_dir = nvim_lsp.util.root_pattern("pubspec.yaml"),
--     init_options = {
--       onlyAnalyzeProjectsWithOpenFiles = "false",
--       suggestFromUnimportedLibraries = "true",
--       closingLabels = "true",
--       outline = "true",
--       fluttreOutline = "false"
--     },
--   },
--   docs = {
--     vscode = "Dart-Code.dart-code",
--     description = [[
-- https://github.com/dart-lang/sdk/tree/master/pkg/analysis_server/tool/lsp_spec
-- 
-- Language server for dart.
-- ]],
--     default_config = {
--       root_dir = [[root_pattern("pubspec.yaml")]],
--     },
--   },
-- };
-- vim:et ts=2 sw=2
