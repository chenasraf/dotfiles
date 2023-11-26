return {
  "chenasraf/text-transform.nvim",
  branch = "develop",
  config = function()
    require("text-transform").setup({
      keymap = {
        ["n"] = "<Leader>~",
        ["v"] = "<Leader>~",
      },
    })
  end,
}
