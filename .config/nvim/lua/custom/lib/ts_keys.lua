local M = {}

M.reverse_table = function(tbl)
  local reversed_table = {}

  for i = #tbl, 1, -1 do
    table.insert(reversed_table, tbl[i])
  end

  return reversed_table
end

M.get_ancestor_keys_generic = function(node_type, key_map)
  return function()
    -- Get the current node at the cursor position
    local current_node = vim.treesitter.get_node()
    if current_node then
      local keys = {}

      -- Traverse ancestors and extract keys
      while current_node do
        local current_node_type = current_node:type()

        -- For JSON, we are interested in "pair" nodes which represent key-value pairs
        if current_node_type == node_type then
          -- Extract the key from the pair node
          local key_node = current_node:child(0)
          if key_node then
            local key = vim.treesitter.get_node_text(key_node, 0)
            key = key_map and key_map(key) or key
            table.insert(keys, key)
          end
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
end

local map = {
  json = M.get_ancestor_keys_generic('pair', function(s) return s:sub(2, -2) end),
  yaml = M.get_ancestor_keys_generic('block_mapping_pair'),
}
M.get_current_keys = function()
  local parser = vim.treesitter.get_parser()
  local lang = parser:lang()
  if map[lang] then
    local ancestor_keys = map[lang]()
    if ancestor_keys then
      return table.concat(ancestor_keys, '.')
    end
    return nil
  end
  return nil
end

M.ts_statusline = function()
  local lang = vim.treesitter.get_parser():lang()
  if not map[lang] then
    return ''
  end
  return M.get_current_keys() or ('<no key: ' .. lang .. '>')
end

return M
