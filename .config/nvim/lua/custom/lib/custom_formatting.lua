local S = {}

local function external_format_stdin(filetype, format_cmd)
  if vim.bo.filetype == filetype then
    local newline = "\n"
    local buftxt = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")

    local command = format_cmd .. [[ <<-'EOF']] .. newline .. buftxt .. newline .. [[EOF]]
    local output = vim.fn.system(command)
    local err = vim.v.shell_error
    if err ~= 0 or output == "" or string.find(output, "command not found:") then
      error("Error: " .. err .. ": " .. output)
    end

    local lines = vim.split(output, "\n")

    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    return true
  end

  return false
end

local function format(force)
  if not force and not AutoFormatEnabled then
    return
  end
  local formatters = {
    -- ["lua"] = "lua-format -i",
    -- ["python"] = "black -",
    -- ["sh"] = "shfmt -i 2 -ci -s -bn",
    -- ["javascript"] = "prettier --stdin-filepath ${INPUT}",
    -- ["typescript"] = "prettier --stdin-filepath ${INPUT}",
    -- ["typescriptreact"] = "prettier --stdin-filepath ${INPUT}",
    ["dart"] = "dart format --output show",
    ["python"] = "black --quiet -",
  }

  for filetype, format_cmd in pairs(formatters) do
    if external_format_stdin(filetype, format_cmd) then
      return
    end
  end

  vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
  vim.api.nvim_echo({ { "Formatted", "Type" } }, true, {})
end

local function format_on_save() format(false) end
local function format_manually() format(true) end

S.format_on_save = format_on_save
S.format_manually = format_manually

return S
