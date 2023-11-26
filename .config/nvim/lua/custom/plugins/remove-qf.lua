vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "dd", ":RemoveQFItem<CR>", { buffer = true, desc = "Remove quickfix item" })
  end,
})

function RemoveQF()
  local curqfidx = vim.fn.line(".") - 1
  local qfall = vim.fn.getqflist()
  table.remove(qfall, curqfidx)
  vim.fn.setqflist(qfall, "r")
  vim.cmd(tostring(curqfidx + 1) .. "cfirst")
  vim.cmd("copen")
end

vim.cmd("command! RemoveQFItem :lua RemoveQF()")

return {}
