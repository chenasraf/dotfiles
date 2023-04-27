vim.keymap.set('n', '<leader>gs', vim.cmd.Git)

local casraf_Fugitive = vim.api.nvim_create_augroup("casraf_fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
    group = casraf_Fugitive,
    pattern = "*",
    callback = function()
        -- print("help", vim.bo.ft)
        if vim.bo.ft ~= "fugitive" then
            return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = {buffer = bufnr, remap = false}
        -- print("great success", vim.bo.ft, bufnr, vim.inspect(opts))
        vim.keymap.set("n", "<leader>gp", function()
            vim.cmd [[ Git push ]]
        end, opts)

        -- rebase always
        vim.keymap.set("n", "<leader>gl", function()
            vim.cmd [[ Git pull --rebase ]]
        end, opts)

        vim.keymap.set("n", "<leader>ga.", function()
            vim.cmd [[ Git add . ]]
        end, opts)

        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
        -- needed if i did not set the branch up correctly
        vim.keymap.set("n", "<leader>gup", ":Git push -u origin ", opts);
    end,
})
