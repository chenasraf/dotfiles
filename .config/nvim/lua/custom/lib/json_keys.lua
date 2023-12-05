local M = {}

M.reverse_table = function(tbl)
  local reversed_table = {}

  for i = #tbl, 1, -1 do
    table.insert(reversed_table, tbl[i])
  end

  return reversed_table
end

M.get_ancestor_keys = function()
  -- Get the current node at the cursor position
  local current_node = vim.treesitter.get_node()
  if current_node then
    local keys = {}

    -- Traverse ancestors and extract keys
    while current_node do
      local node_type = current_node:type()

      -- For JSON, we are interested in "pair" nodes which represent key-value pairs
      if node_type == 'pair' then
        -- Extract the key from the pair node
        local key_node = current_node:child(0)
        local key = vim.treesitter.get_node_text(key_node, 0):sub(2, -2)
        table.insert(keys, key)
      end

      -- Move to the parent node
      current_node = current_node:parent()
    end

    if #keys == 0 then
      return nil
    end

    return M.reverse_table(keys)
  end

  return nil
end

M.ts_statusline = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  if not clients or not bufnr then
    return ''
  end
  local parser = vim.treesitter.get_parser()
  local lang = parser:lang()
  if lang == 'json' then
    local ancestor_keys = M.get_ancestor_keys()
    if ancestor_keys then
      return table.concat(ancestor_keys, '.')
    end
    return '.'
  end
  return ''
end

return M
