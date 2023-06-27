vim.keymap.set('n', '<leader>gs', vim.cmd.Git)

local casraf_fugitive = vim.api.nvim_create_augroup("casraf_fugitive", {})

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
    -- print("great success", vim.bo.ft, bufnr, vim.inspect(opts))
    vim.keymap.set("n", "gp", "]]k", opts)

    -- rebase always
    vim.keymap.set("n", "<leader>gl", function()
      vim.cmd [[ Git pull --rebase ]]
    end, opts)

    vim.keymap.set("n", "<leader>gaa", function()
      vim.cmd [[ Git add . ]]
    end, opts)

    -- push with upstream
    vim.keymap.set("n", "<leader>gup", function()
      local current_branch = vim.fn.FugitiveHead()

      local cmd = ":Git push -u origin " .. current_branch

      vim.fn.inputsave()
      vim.fn.input(cmd)
    end, opts);
  end,
})
