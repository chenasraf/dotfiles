function ToggleQuotes()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local line_text = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
  local quotes = { ["'"] = '"', ['"'] = '`', ['`'] = "'" }

  -- Find the nearest quote char to the left of the cursor position
  local left_quote_char = nil
  local i = col - 1
  while i >= 1 do
    if quotes[line_text:sub(i, i)] then
      left_quote_char = line_text:sub(i, i)
      break
    end
    i = i - 1
  end

  -- Find the nearest quote char to the right of the cursor position
  local right_quote_char = nil
  i = col
  if left_quote_char then
    while i <= #line_text do
      if line_text:sub(i, i) == left_quote_char then
        right_quote_char = line_text:sub(i, i)
        break
      end
      i = i + 1
    end

    if left_quote_char == right_quote_char then
      -- Determine the quote type to use for replacement
      local quote_type = left_quote_char or right_quote_char
      local next_quote_type = quotes[quote_type]

      -- Replace the quotes in the line text
      local new_line_text = line_text
      local replaced_left = false
      local replaced_right = false
      for i = col - 1, 1, -1 do
        local c = line_text:sub(i, i)
        if not replaced_left and c == quote_type then
          new_line_text = new_line_text:sub(1, i - 1) .. next_quote_type .. new_line_text:sub(i + 1)
          replaced_left = true
        end
      end
      for i = col, #line_text do
        local c = line_text:sub(i, i)
        if not replaced_right and c == quote_type then
          new_line_text = new_line_text:sub(1, i - 1) .. next_quote_type .. new_line_text:sub(i + 1)
          replaced_right = true
        end
      end
      vim.api.nvim_buf_set_lines(0, line - 1, line, false, { new_line_text })
    else
      print("No quotes found on line " .. line .. ":" .. col)
    end
  end
end

vim.cmd('command! ToggleQuotes lua ToggleQuotes()')
