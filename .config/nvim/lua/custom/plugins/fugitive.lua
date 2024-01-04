-- Global (non-buffer) fugitive mappings
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = '[fugitive] status' })
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { silent = true, desc = "[fugitive] blame" })
vim.keymap.set("n", "<leader>gB", ":GBrowse<CR>", { silent = true, desc = "[G]it [B]rowse current file/line" })
vim.api.nvim_create_user_command(
  "Browse",
  function(opts)
    local current_row = vim.fn.line(".")
    local current_col = vim.fn.col(".")
    local cmd = [[!open -u "]] .. opts.args .. [[\#L]] .. current_row .. [[:]] .. current_col .. [["]]
    vim.cmd(cmd, { silent = true })
  end,
  { nargs = 1, force = true })

local casraf_fugitive = vim.api.nvim_create_augroup("casraf_fugitive", {})

vim.api.nvim_clear_autocmds({ group = casraf_fugitive })
local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWinEnter", {
  group = casraf_fugitive,
  pattern = "*",
  callback = function()
    -- print("help", vim.bo.ft)
    if vim.bo.ft ~= "fugitive" then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local opts = { buffer = bufnr, remap = false }
    local function optc(desc)
      return vim.tbl_extend("force", opts, { desc = desc })
    end

    vim.keymap.set("n", "<leader>gb", function()
      vim.api.nvim_feedkeys(":Git checkout ", "n", true)
    end, optc("[fugitive] checkout [b]ranch"))

    vim.keymap.set("n", "<leader>gB", function()
      vim.api.nvim_feedkeys(":Git checkout -b ", "n", true)
    end, optc("[fugitive] create [B]ranch"))

    vim.keymap.set("n", "<leader>gp", function()
      local current_branch = vim.fn.FugitiveHead()
      local cmd = "Git push origin @:refs/heads/" .. current_branch
      vim.print(cmd)
      vim.cmd(cmd)
    end, optc("[fugitive] [P]ush all unpushed commits"))

    -- rebase always
    vim.keymap.set("n", "<leader>gl", function()
      vim.fn.system("git diff-index --quiet HEAD --")
      local has_changes = vim.v.shell_error == 1
      if has_changes then
        local date = vim.fn.strftime("%Y-%m-%d %H:%M:%S")
        local msg = "Fugitive rebase " .. date
        vim.cmd("Git stash save -u \"" .. msg .. "\"")
      end

      vim.cmd [[ Git pull --rebase ]]

      if has_changes then
        vim.cmd [[ Git stash pop ]]
      end
    end, optc("[fugitive] pu[l]l with rebase"))

    vim.keymap.set("n", "<leader>gaa", function()
      vim.cmd [[ Git add . ]]
    end, optc("[fugitive] [a]dd all"))

    -- push with upstream
    vim.keymap.set("n", "<leader>gup", function()
      local current_branch = vim.fn.FugitiveHead()

      local raw_cmd = ":Git push -u origin " .. current_branch
      local cmd = vim.api.nvim_replace_termcodes(raw_cmd, true, true, true)
      vim.print(cmd)
      vim.api.nvim_feedkeys(cmd, "n", true)
    end, optc("[fugitive] [u]pstream push"))

    vim.keymap.set("n", "<leader>gf", ":Git fetch<CR>", optc("[fugitive] [f]etch"))
  end,
})

return {}
