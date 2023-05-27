local nls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

nls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<Leader>f", function()
        if vim.bo.filetype == "dart" then
          vim.cmd("silent !dart format --line-length 120 %:p")
          -- vim.lsp.buf.execute_command({
          --   command = "_dart.applySourceChange",
          --   arguments = { vim.lsp.buf_get_clients()[1].id, vim.lsp.util.make_range_params() },
          -- })
        else
          vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
        end
      end, { buffer = bufnr, desc = "[lsp] format" })

      -- format on save
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      vim.api.nvim_create_autocmd(event, {
        buffer = bufnr,
        group = group,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = async })
        end,
        desc = "[lsp] format on save",
      })
    end

    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end,
})

local function get_lines(bufnr, range)
  local start_line = range.row
  local start_col = range.col
  local end_line = range.end_row
  local end_col = range.end_col

  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)
  return lines
end

local function replace_range(bufnr, range, text)
  local start_line = range.row
  local start_col = range.col
  local end_line = range.end_row
  local end_col = range.end_col

  local lines = get_lines(bufnr, range)
  lines[1] = lines[1]:sub(1, start_col) .. text .. lines[1]:sub(end_col + 1)
  vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, false, lines)
end

local i18next = {
  method = nls.methods.CODE_ACTION,
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = vim.fs.dirname(vim.fs.find({"package.json"}, { upward = true })[1]),
  generator = {
    fn = function(ctx)
      local is_range = ctx.range and vim.tbl_islist(ctx.range)
      if is_range then
        return {
          title = "Extract i18n key",
          action = function()
            local lines = get_lines(ctx.bufnr, ctx.range)
            local range_text = lines[1]:sub(ctx.range.col, ctx.range.end_col)
            local key = vim.fn.input("JSON path: ")
            local replaced = replace_range(ctx.bufnr, ctx.range, "t('" .. key .. "')")
            -- use jq to add to en-US.json
            local jq = vim.fn.executable("jq")
            jq "'. + {"' .. key .. '": "' .. range_text .. '"}' en-US.json > en-US.json"
          end
        }
      else
        return {
          title = "Extract i18n key",
          action = function()
            local key = vim.fn.input("JSON path: ")
            local text = vim.fn.input("Text: ")
            -- get surrounding quotes from cursor and get the range of the text inside it
            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            -- get the positions of the surrounding quotes
            local start_pos = vim.fn.searchpos("'", "bcn", cursor_pos)
            local end_pos = vim.fn.searchpos("'", "ecn", cursor_pos)
            -- get the range of the text inside the quotes
            local start_line = start_pos[1]
            local start_col = start_pos[2]
            local end_line = end_pos[1]
            local end_col = end_pos[2]

            local range = {
              row = start_line,
              col = start_col,
              end_row = end_line,
              end_col = end_col,
            }

            local replaced = replace_range(ctx.bufnr, range, "t('" .. key .. "')")
            -- use jq to add to en-US.json
            local jq = vim.fn.executable("jq")
            jq "'. + {"' .. key .. '": "' .. text .. '"}' en-US.json > en-US.json"
          end
        }
      end
    end,
  },
}


nls.register(i18next)
