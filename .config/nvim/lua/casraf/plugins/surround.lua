-- Block comment delimiters for the current filetype, taken from Comment.nvim so
-- `ds c` undoes exactly what `gb` wrote.
local function block_comment()
  local ok, ft = pcall(require, 'Comment.ft')
  local cstr = ok and ft.get(vim.bo.filetype, require('Comment.utils').ctype.blockwise) or '/*%s*/'
  local left, right = cstr:match('^(.-)%%s(.-)$')
  return vim.trim(left), vim.trim(right)
end

return {
  "kylechui/nvim-surround",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  config = function()
    local config = require("nvim-surround.config")
    require("nvim-surround").setup({
      surrounds = {
        ["c"] = {
          add = function()
            local left, right = block_comment()
            return { { left }, { right } }
          end,
          find = function()
            local left, right = block_comment()
            return config.get_selection({ pattern = vim.pesc(left) .. ".-" .. vim.pesc(right) })
          end,
          -- Also strips the padding of `/* obj */`, as written by `gbc`.
          delete = function()
            local left, right = block_comment()
            return config.get_selections({
              char = "c",
              pattern = "^(" .. vim.pesc(left) .. "%s?)().-(%s?" .. vim.pesc(right) .. ")()$",
            })
          end,
        },
      },
    })
  end
}
