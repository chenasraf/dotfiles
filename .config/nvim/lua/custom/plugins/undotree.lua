vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")

-- if has("persistent_undo")
--    let target_path = expand('~/.undodir')
--
--     " create the directory and any parent directories
--     " if the location does not exist.
--     if !isdirectory(target_path)
--         call mkdir(target_path, "p", 0700)
--     endif
--
--     let &undodir=target_path
--     set undofile
-- endif

-- if vim.fn.has("persistent_undo") then
--   vim.o.undodir = vim.fn.expand("~/.undodir")
--   vim.o.undofile = true
-- end

return {
  "mbbill/undotree"
}
