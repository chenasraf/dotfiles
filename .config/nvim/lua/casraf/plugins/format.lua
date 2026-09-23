local prettier = { "prettier" }

-- mason.nvim puts its own bin directory at the front of $PATH, so a `:MasonInstall
-- prettier` silently shadows the copy sofmani provisions, and the two drift to
-- different versions that format the same file differently. Resolve the provisioned
-- binary by path so mason can't win.
local function provisioned_prettier()
  local pnpm = vim.env.PNPM_HOME and (vim.env.PNPM_HOME .. "/bin/prettier")
  if pnpm and vim.fn.executable(pnpm) == 1 then
    return pnpm
  end
  return "prettier"
end

return {
  "stevearc/conform.nvim",
  lazy = false,
  config = function()
    local conform = require("conform")
    local custom_formatting = require("casraf.lib.custom_formatting")

    conform.setup({
      formatters_by_ft = {
        css = prettier,
        graphql = prettier,
        html = prettier,
        javascript = prettier,
        javascriptreact = prettier,
        json = prettier,
        jsonc = prettier,
        less = prettier,
        markdown = prettier,
        ["markdown.mdx"] = prettier,
        scss = prettier,
        svelte = prettier,
        typescript = prettier,
        typescriptreact = prettier,
        vue = prettier,
        yaml = prettier,
        dart = { "dart_format" },
        python = { "black" },
      },
      formatters = {
        prettier = {
          command = require("conform.util").find_executable({ "node_modules/.bin/prettier" }, provisioned_prettier()),
          -- Prettier 3 treats .gitignore as an ignore file. $HOME/.gitignore ignores
          -- `*`, so any file whose project root resolves to $HOME comes back from
          -- prettier untouched, exit 0, with nothing to say it was skipped.
          prepend_args = { "--ignore-path", ".prettierignore" },
        },
      },
      -- `fallback` means: run the configured external formatter when there is one, and
      -- only reach for the LSP when there isn't, so prettier and ts_ls never both fire.
      -- It lives here rather than in the per-call opts so that list_formatters_to_run
      -- resolves the same way the format call does.
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = custom_formatting.format_on_save,
      -- Plenty of filetypes here have neither an external formatter nor an LSP that
      -- formats; saving those shouldn't nag.
      notify_no_formatters = false,
    })

    -- 'formatexpr' is deliberately left alone: prettier can't format a range, so
    -- pointing it at conform turns `gq` into a no-op instead of wrapping the paragraph.

    vim.keymap.set("n", "=", custom_formatting.format_manually, { desc = "Format buffer" })

    vim.api.nvim_create_user_command("Prettier", function()
      conform.format({ formatters = { "prettier" }, lsp_format = "never", async = true })
    end, { desc = "Format current buffer with prettier" })
  end,
}
