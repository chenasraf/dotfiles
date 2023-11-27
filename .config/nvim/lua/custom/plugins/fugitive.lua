vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = '[fugitive] status' })
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { silent = true, desc = "[fugitive] blame" })

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
    local function optc(desc)
      return vim.tbl_extend("force", opts, { desc = desc })
    end
    -- print("great success", vim.bo.ft, bufnr, vim.inspect(opts))
    vim.keymap.set("n", "<leader>gp", function()
      local current_branch = vim.fn.FugitiveHead()

      local cmd = ":Git push origin @:refs/heads/" .. current_branch
      local esc_cmd = vim.api.nvim_replace_termcodes(cmd, true, true, true)
      vim.api.nvim_feedkeys(esc_cmd, "n", true)
    end, optc("[fugitive] [P]ush all unpushed commits"))

    -- rebase always
    vim.keymap.set("n", "<leader>gl", function()
      vim.cmd [[ Git pull --rebase ]]
    end, optc("[fugitive] pu[l]l with rebase"))

    vim.keymap.set("n", "<leader>gaa", function()
      vim.cmd [[ Git add . ]]
    end, optc("[fugitive] [a]dd all"))

    -- push with upstream
    vim.keymap.set("n", "<leader>gup", function()
      local current_branch = vim.fn.FugitiveHead()

      local cmd = ":Git push -u origin " .. current_branch
      local esc_cmd = vim.api.nvim_replace_termcodes(cmd, true, true, true)
      vim.api.nvim_feedkeys(esc_cmd, "n", true)
    end, optc("[fugitive] [u]pstream push"))

    vim.keymap.set("n", "<leader>gf", ":Git fetch<CR>", optc("[fugitive] [f]etch"))
  end,
})

return {}
