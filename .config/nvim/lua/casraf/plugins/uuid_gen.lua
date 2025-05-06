return {
  'L3MON4D3/LuaSnip',
  event = 'VeryLazy',
  config = function()
    local function uuid()
      local id, _ = vim.fn.system('uuidgen'):gsub('\n', '')
      return id
    end

    local luasnip = require('luasnip')
    local s, sn   = luasnip.snippet, luasnip.snippet_node
    local t, i, d = luasnip.text_node, luasnip.insert_node, luasnip.dynamic_node
    luasnip.add_snippets('global', {
      s({
        trig = 'uuid',
        name = 'UUID',
        dscr = 'Generate a unique UUID'
      }, {
        d(1, function() return sn(nil, i(1, uuid())) end)
      })
    })
  end
}
