return {
  'MunifTanjim/prettier.nvim',
  -- dependencies = { 'jose-elias-alvarez/null-ls.nvim' },
  config = function()
    require("prettier").setup({
      bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
      filetypes = {
        "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "less",
        "markdown",
        "scss",
        "typescript",
        "typescriptreact",
        "yaml",
      },
    })

    -- local nls = require("null-ls")
    local custom_formatting = require("casraf.lib.custom_formatting")
    local format_on_save = custom_formatting.format_on_save
    local format_manually = custom_formatting.format_manually

    local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
    local event = "BufWritePre" -- or "BufWritePost"
    -- local async = event == "BufWritePost"

    vim.keymap.set("n", "=", format_manually, { desc = "[nolsp] format" })

    -- format on save
    vim.api.nvim_clear_autocmds({ group = group })
    vim.api.nvim_create_autocmd(event, {
      group = group,
      callback = format_on_save,
      desc = "[lsp] format on save",
    })

    vim.api.nvim_create_user_command('Prettier', function()
      local file = vim.fn.expand('%')

      -- Find project root by looking for package.json
      local function find_project_root()
        local current = vim.fn.expand('%:p:h')
        while current ~= '/' do
          if vim.fn.filereadable(current .. '/package.json') == 1 then
            return current
          end
          current = vim.fn.fnamemodify(current, ':h')
        end
        return nil
      end

      local project_root = find_project_root()
      local cmd

      if project_root then
        -- Check if prettier exists in node_modules
        local local_prettier = project_root .. '/node_modules/.bin/prettier'
        if vim.fn.executable(local_prettier) == 1 then
          cmd = 'cd ' .. vim.fn.shellescape(project_root) .. ' && pnpm prettier --write ' .. vim.fn.shellescape(file)
          vim.cmd('!' .. cmd)
          return
        end
      end

      -- Fall back to system-wide prettier
      if vim.fn.executable('prettier') == 1 then
        -- Check for global config files
        local config_locations = {
          vim.fn.expand('~/.prettierrc'),
          vim.fn.expand('~/.prettierrc.json'),
          vim.fn.expand('~/.prettierrc.yml'),
          vim.fn.expand('~/.prettierrc.yaml'),
          vim.fn.expand('~/.prettierrc.js'),
          vim.fn.expand('~/.config/prettier/.prettierrc'),
          vim.fn.expand('~/.config/prettier/config.json'),
        }

        local config_found = false
        for _, config in ipairs(config_locations) do
          if vim.fn.filereadable(config) == 1 then
            config_found = true
            break
          end
        end

        if not config_found then
          print('Warning: No global Prettier config found. Create one at:')
          print('  ~/.prettierrc (JSON)')
          print('  ~/.prettierrc.json')
          print('  ~/.config/prettier/.prettierrc')
        end

        cmd = 'prettier --write ' .. vim.fn.shellescape(file)
        vim.cmd('!' .. cmd)
      else
        print('Error: Prettier not found (neither local nor global)')
      end
    end, {})

    -- nls.setup({
    --   ---@diagnostic disable-next-line: unused-local
    --   on_attach = function(client, bufnr)
    --     -- if client.supports_method("textDocument/formatting") then
    --     vim.keymap.set("n", "<Leader>F", format_manually, { buffer = bufnr, desc = "[lsp] format" })
    --     -- end
    --
    --     -- if client.supports_method("textDocument/rangeFormatting") then
    --     vim.keymap.set("x", "<Leader>F", format_manually, { buffer = bufnr, desc = "[lsp] format" })
    --     -- end
    --   end,
    -- })
  end
}
