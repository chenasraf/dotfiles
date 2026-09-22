local S = {}

local OPTS = { timeout_ms = 3000 }

--- Options for conform's format-on-save hook, or nil to leave the buffer alone.
function S.format_on_save()
  if not AutoFormatEnabled then
    return nil
  end
  return OPTS
end

--- Format the whole buffer and report which formatter did it.
function S.format_manually()
  local conform = require("conform")
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.fn.expand("%:t")

  local formatters, lsp = conform.list_formatters_to_run(bufnr)
  local names = vim.tbl_map(function(formatter)
    return formatter.name
  end, formatters)
  if lsp then
    table.insert(names, "LSP")
  end

  if #names == 0 then
    vim.api.nvim_echo({
      { "No formatter for ", "WarningMsg" },
      { filename,            "String" },
    }, false, {})
    return
  end

  conform.format(vim.tbl_extend("force", OPTS, { bufnr = bufnr, async = true }), function(err)
    -- A server with nothing to change answers the format request with null, which
    -- conform surfaces as an error. The buffer is already clean; say so.
    if err and err:find("No result returned from LSP formatter", 1, true) then
      err = nil
    end
    if err then
      vim.api.nvim_echo({
        { "Could not format ", "WarningMsg" },
        { filename,            "String" },
        { ": " .. err,         "WarningMsg" },
      }, false, {})
      return
    end
    -- Deliberately not keyed off the callback's did_edit: an already-formatted
    -- buffer edits nothing, and that is a success, not a missing formatter.
    vim.api.nvim_echo({
      { "Formatted " },
      { filename,                              "String" },
      { " using " .. table.concat(names, ", ") },
    }, true, {})
  end)
end

return S
