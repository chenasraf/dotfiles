local M = {}

--- Close the current buffer through barbar, confirming first when it has unsaved
--- changes — plain `:BufferClose` aborts with E89 instead of asking.
function M.close_current()
  if not vim.bo.modified then
    vim.cmd('BufferClose')
    return
  end

  local name = vim.fn.expand('%:t')
  if name == '' then name = '[No Name]' end

  local choice = vim.fn.confirm(
    ('%s has unsaved changes. Close anyway?'):format(name),
    '&Yes\n&No',
    2
  )
  if choice == 1 then
    vim.cmd('BufferClose!')
  end
end

return M
