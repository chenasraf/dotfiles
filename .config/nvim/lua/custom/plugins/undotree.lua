vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")

if vim.fn.has("persistent_undo") then
  local target_path = vim.fn.expand('~/.undodir')

  -- create the directory and any parent directories
  -- if the location does not exist.
  if not vim.fn.isdirectory(target_path) then
    vim.fn.mkdir(target_path, "p", 0700)
  end

  vim.o.undodir = target_path
  vim.o.undofile = true
end

return {
  "mbbill/undotree"
}
