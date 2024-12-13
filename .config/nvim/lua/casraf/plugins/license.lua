local last_license = nil
local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node

local config = function()
  local username = vim.fn.system('git config user.name')
  username = string.gsub(username, '\n', '')
  local email = vim.fn.system('git config user.email')
  email = string.gsub(email, '\n', '')
  local author = username .. ' <' .. email .. '>'
  local getcomment = function()
    local lc = vim.bo.commentstring
    lc = string.gsub(lc, '%%s', '')
    return lc or '//'
  end

  ls.add_snippets('all', {
    s('spdx', {
      d(1, function()
        local lc = getcomment()
        return sn(nil, {
          t(lc),
          t('SPDX-FileCopyrightText: '),
          i(1, author),
          t({ '', '' }),
          t(lc),
          t('SPDX-License-Identifier: '),
          i(2, last_license or 'MIT'),
        })
      end),
    })
  }, { key = 'spdx' })

  vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
  vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
  vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

  vim.keymap.set({ "i", "s" }, "<C-E>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end, { silent = true })

  vim.api.nvim_create_user_command('SPDX', function(opts)
    local license = opts.args
    if license == nil or license == '' then
      license = last_license or 'MIT'
    end
    last_license = license
    print('License set to:', license)
    -- local snippets = ls.get_snippets('all')
    -- local spdx
    -- for _, snip in pairs(snippets) do
    --   if snip.name == 'spdx' then
    --     spdx = snip
    --   end
    -- end
    -- spdx:trigger_expand()
  end, { nargs = '*' })
end

return {
  name = 'license',
  dir = '.',
  config = config
}
