require("oil").setup({
  columns = {
    "icon",
    "size"
  },
  view_options = {
    show_hidden = true,
    ---@diagnostic disable-next-line: unused-local
    is_always_hidden = function(name, bufnr)
      if name == '.git' then
        return true
      end
      return false
    end
  },
})
