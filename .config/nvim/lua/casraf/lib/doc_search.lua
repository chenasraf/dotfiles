local M = {}

M.config = {
  doc_sources = {},
  keymap = "<leader>ds",
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  if M.config.keymap then
    vim.keymap.set({ "n", "v" }, M.config.keymap, function() M.search() end, { desc = "Search Documentation" })
  end
end

local function get_visual_selection()
  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' and mode ~= '\22' then
    return nil
  end

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_row, start_col = start_pos[2], start_pos[3]
  local end_row, end_col = end_pos[2], end_pos[3]

  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  if #lines == 0 then return nil end

  lines[1] = lines[1]:sub(start_col)
  lines[#lines] = lines[#lines]:sub(1, end_col - (start_row == end_row and start_col - 1 or 0))

  ---@diagnostic disable-next-line: param-type-mismatch
  local selection = table.concat(lines, ' ')

  local unquoted = selection:match('^"(.-)"$')
      or selection:match("^'(.-)'$")
      or selection:match('^`(.-)`$')
      or selection

  return unquoted
end

local function get_word()
  if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' or vim.fn.mode() == '' then
    return get_visual_selection()
  else
    return vim.fn.expand("<cword>")
  end
end

function M.search()
  local filetype = vim.bo.filetype
  local word = get_word()
  if not word or word == "" then
    vim.notify("No word selected", vim.log.levels.WARN)
    return
  end

  local sources = M.config.doc_sources[filetype]
  if not sources then
    vim.notify("No doc sources for filetype: " .. filetype, vim.log.levels.INFO)
    return
  end

  local function open_doc(source)
    local url = source.url:gsub("{query}", vim.fn.escape(word, " "))
    local open_cmd

    if vim.fn.has("mac") == 1 then
      open_cmd = "open"
    elseif vim.fn.has("unix") == 1 then
      open_cmd = "xdg-open"
    elseif vim.fn.has("win32") == 1 then
      open_cmd = "start"
    else
      vim.notify("Unsupported OS for opening URLs", vim.log.levels.ERROR)
      return
    end

    vim.fn.jobstart({ open_cmd, url }, { detach = true })
  end

  if #sources == 1 then
    open_doc(sources[1])
  else
    vim.ui.select(sources, {
      prompt = "Select Documentation Source",
      format_item = function(item) return item.name end,
    }, function(choice)
      if choice then open_doc(choice) end
    end)
  end
end

return M
