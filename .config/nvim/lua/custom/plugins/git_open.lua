-- usage: :GitOpen .|repo|branch|commit|file [...]
vim.api.nvim_create_user_command('GitOpen', function(opts)
  local args = opts.args
  local cmd = "git open"
  if #args > 0 then
    cmd = cmd .. " " .. args
    vim.cmd(":silent !" .. cmd)
  else
    local types = { "branch", "repo", "commit", "file" }
    local type_map = { repo = "Project", branch = "Current branch", commit = "Commit", file = "File" }
    vim.ui.select(types, {
      prompt = "Git open",
      format_item = function(item) return type_map[item] end
    }, function(selected)
      local extras = ""
      if selected == "file" then
        extras = vim.fn.expand("%")
      end
      if extras ~= "" then
        selected = selected .. " " .. extras
      end
      vim.cmd("GitOpen " .. selected)
    end)
  end
end, { nargs = '*' })
vim.keymap.set("n", "<leader>go", ":GitOpen<CR>", { desc = "Git open", silent = true })
vim.keymap.set("n", "<leader>gOp", ":GitOpen repo<CR>", { desc = "Git open repo", silent = true })
vim.keymap.set("n", "<leader>gOb", ":GitOpen branch<CR>", { desc = "Git open branch", silent = true })
vim.keymap.set("n", "<leader>gOc", ":GitOpen commit<CR>", { desc = "Git open commit", silent = true })
vim.keymap.set("n", "<leader>gOf", ":GitOpen file<CR>", { desc = "Git open file", silent = true })

return {}
