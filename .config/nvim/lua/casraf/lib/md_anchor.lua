local M = {}

local function default_gx()
  local cfile = vim.fn.expand("<cfile>")
  if cfile and cfile ~= "" then
    vim.ui.open(cfile)
  end
end

local function header_to_anchor(text)
  text = text:lower()
  text = text:gsub("`([^`]*)`", "%1")
  text = text:gsub("[^%w%s%-]", "")
  text = text:gsub("%s+", "-")
  return text
end

local function get_link_target()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  local search_start = 1
  while true do
    local close_bracket = line:find("%]%(", search_start)
    if not close_bracket then break end

    local paren_start = close_bracket + 2
    local paren_end = line:find("%)", paren_start)
    if not paren_end then break end

    if col >= paren_start and col <= paren_end then
      return line:sub(paren_start, paren_end - 1)
    end

    search_start = paren_end + 1
  end

  return nil
end

local function jump_to_anchor(anchor)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i, line_text in ipairs(lines) do
    local header = line_text:match("^#+%s+(.*)")
    if header and header_to_anchor(header) == anchor then
      vim.api.nvim_win_set_cursor(0, { i, 0 })
      return true
    end
  end
  return false
end

function M.gx()
  if vim.bo.filetype ~= "markdown" then
    default_gx()
    return
  end

  local target = get_link_target()
  if not target then
    default_gx()
    return
  end

  local anchor = target:match("^#(.+)")
  if not anchor then
    default_gx()
    return
  end

  if not jump_to_anchor(anchor) then
    vim.notify("Anchor not found: #" .. anchor, vim.log.levels.WARN)
  end
end

function M.setup()
  vim.keymap.set("n", "gx", M.gx, { desc = "Smart gx: markdown anchors or default" })
end

return M
