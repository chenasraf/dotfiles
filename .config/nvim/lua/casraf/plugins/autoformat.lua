-- autoformat.lua
--
-- Use your language server to automatically format your code on save.
-- Adds additional commands as well to manage the behavior

-- Switch for controlling whether you want autoformatting.
--  Use :AutoFormat to toggle autoformatting on or off
AutoFormatEnabled = true
vim.api.nvim_create_user_command('AutoFormat', function()
  AutoFormatEnabled = not AutoFormatEnabled
  print('Setting autoformatting to: ' .. tostring(AutoFormatEnabled))
end, {})

return {
  'neovim/nvim-lspconfig',
  config = function()
    -- Create an augroup that is used for managing our formatting autocmds.
    --      We need one augroup per client to make sure that multiple clients
    --      can attach to the same buffer without interfering with each other.
    local _augroups = {}
    local get_augroup = function(client)
      if not _augroups[client.id] then
        local group_name = 'kickstart-lsp-format-' .. client.name
        local id = vim.api.nvim_create_augroup(group_name, { clear = true })
        _augroups[client.id] = id
      end

      return _augroups[client.id]
    end

    -- Whenever an LSP attaches to a buffer, we will run this function.
    --
    -- See `:help LspAttach` for more information about this autocmd event.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),
      -- This is where we attach the autoformatting for reasonable clients
      callback = function(args)
        local client_id = args.data.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local bufnr = args.buf

        -- Only attach to clients that support document formatting
        if not client.server_capabilities.documentFormattingProvider then
          return
        end

        -- TS Server is handled by null-ls/prettier
        if client.name == 'ts_ls' or client.name == 'tsserver' then
          return
        end

        -- Create an autocmd that will run *before* we save the buffer.
        --  Run the formatting command for the LSP that has just attached.
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = get_augroup(client),
          buffer = bufnr,
          callback = function()
            local custom_formatting = require("casraf.lib.custom_formatting")
            local format_on_save = custom_formatting.format_on_save
            format_on_save()
          end,
        })
      end,
    })
  end,
}
