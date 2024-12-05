-- usage: :GitOpen .|repo|branch|commit|file [...]
vim.api.nvim_create_user_command('GitOpen', function(opts)
  local args = opts.args
  local cmd = "git open"
  if #args > 0 then
    cmd = cmd .. " " .. args
    print("Running: " .. cmd)
    vim.cmd(":silent !" .. cmd)
  else
    local types = { "branch", "pr", "prs", "repo", "commit", "file" }
    local type_map = {
      repo = "Project",
      branch = "Current branch",
      commit = "Commit",
      file = "File",
      pr = "Create/open Pull Request",
      prs = "PRs list"
    }
    vim.ui.select(types, {
      prompt = "Git open",
      format_item = function(item) return type_map[item] end
    }, function(selected)
      if not selected then return end
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

vim.keymap.set("n", "<leader>gO", ":GitOpen<CR>", { desc = "Git open", silent = true })
vim.keymap.set("n", "<leader>gor", ":GitOpen repo<CR>", { desc = "Git open repo", silent = true })
vim.keymap.set("n", "<leader>goa", ":GitOpen actions<CR>", { desc = "Git open actions", silent = true })
vim.keymap.set("n", "<leader>gob", ":GitOpen branch<CR>", { desc = "Git open branch", silent = true })
vim.keymap.set("n", "<leader>goc", ":GitOpen commit<CR>", { desc = "Git open commit", silent = true })
vim.keymap.set("n", "<leader>gof", ":GitOpen file<CR>", { desc = "Git open file", silent = true })
vim.keymap.set("n", "<leader>gop", ":GitOpen prs<CR>", { desc = "Git open PRs list", silent = true })
vim.keymap.set("n", "<leader>goP", ":GitOpen pr<CR>", { desc = "Git open PR", silent = true })

require('which-key').add({
  { '<leader>go', group = '[G]it[O]pen ...' },
  { '<leader>gO', group = '[G]it[O]pen' },
})

return {}
