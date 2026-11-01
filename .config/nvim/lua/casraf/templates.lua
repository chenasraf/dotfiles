-- Starting content for files that open empty, keyed by filename glob.
--
-- Tokens filled in from the file's path, for /src/actor/player.hpp:
--   {{dirname}}   actor
--   {{filename}}  player.hpp
--   {{name}}      player
--   {{ext}}       hpp
-- {{cursor}} marks where the cursor lands, the last line when a template has none.
-- Any other {{token}} stays as written.

local function namespace(...)
  local lines = { ... }
  vim.list_extend(lines, { 'namespace {{dirname}} {', '', '{{cursor}}', '', '} // namespace {{dirname}}' })
  return lines
end

local templates = {
  ['*.{h,hh,hpp,hxx}'] = namespace('#pragma once', '', ''),
  ['*.{cpp,cc,cxx}'] = namespace(),
}

local function tokens(path)
  return {
    dirname = vim.fn.fnamemodify(path, ':h:t'),
    filename = vim.fn.fnamemodify(path, ':t'),
    name = vim.fn.fnamemodify(path, ':t:r'),
    ext = vim.fn.fnamemodify(path, ':e'),
  }
end

local group = vim.api.nvim_create_augroup('casraf_templates', { clear = true })

for pattern, template in pairs(templates) do
  -- Oil writes a new file to disk as soon as its buffer is saved, so opening it fires
  -- BufReadPost on an empty file rather than BufNewFile.
  vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
    group = group,
    pattern = pattern,
    callback = function(args)
      local buf = args.buf
      if vim.api.nvim_buf_line_count(buf) > 1 or vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] ~= '' then
        return
      end

      local values = tokens(vim.api.nvim_buf_get_name(buf))
      local cursor = { #template, 0 }
      local lines = {}
      for i, line in ipairs(template) do
        line = line:gsub('{{(%w+)}}', function(token)
          return values[token]
        end)
        local col = line:find('{{cursor}}', 1, true)
        if col then
          cursor = { i, col - 1 }
          line = line:gsub('{{cursor}}', '', 1)
        end
        lines[i] = line
      end

      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.api.nvim_win_set_cursor(0, cursor)
    end,
  })
end
