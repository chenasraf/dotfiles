vim.keymap.set("n", "<leader>lr", function()
  vim.cmd("LspRestart")
  vim.notify("LSP Restarted")
end, { desc = "[L]SP [R]estart", silent = true })
vim.keymap.set("n", "<leader>li", ":LspInfo<CR>", { desc = "[L]SP [I]nfo", silent = true })
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, wrap = true, float = true }) end,
  { desc = 'Go to previous diagnostic message', silent = true })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, wrap = true, float = true }) end,
  { desc = 'Go to next diagnostic message', silent = true })
vim.keymap.set('n', '<leader>tE', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message', silent = true })
vim.keymap.set('n', '<leader>tQ', vim.diagnostic.setloclist, { desc = 'Open diagnostics list', silent = true })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  vim.keymap.set({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action, { desc = 'Code [A]ction', silent = true })
  vim.keymap.set({ 'n', 'i', 'v' }, '<F4>', vim.lsp.buf.code_action, { desc = 'Code [A]ction', silent = true })
  vim.keymap.set({ "n", "v", "i" }, "<F2>", vim.lsp.buf.rename)

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('H', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('<leader>h', function()
    local new_val = not vim.lsp.inlay_hint.is_enabled({})
    vim.lsp.inlay_hint.enable(new_val)
    vim.api.nvim_echo({ { "Inlay Hints: " .. (new_val and "On" or "Off"), "Type" } }, true, {})
  end, 'Toggle Inlay Hints')
  vim.keymap.set("i", "<C-H>", vim.lsp.buf.signature_help, { buffer = true, desc = "[LSP] Signature Documentation" })

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    local folders = vim.lsp.buf.list_workspace_folders()
    require('telescope.pickers').new({}, {
      prompt_title = "Workspace Folders",
      finder = require('telescope.finders').new_table {
        results = folders,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry,
            ordinal = entry,
          }
        end,
      },
    }):find()
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    local custom_formatting = require("casraf.lib.custom_formatting")
    local format_manually = custom_formatting.format_manually
    format_manually()
  end, { desc = 'Format current buffer with LSP' })
end

local group = vim.api.nvim_create_augroup("flutter", {})
vim.api.nvim_clear_autocmds({ group = group })
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function(args)
    local fname = vim.api.nvim_buf_get_name(args.buf)
    -- if not fname:match("%.dart$") then return end

    local pubspec = vim.fs.find("pubspec.yaml", {
      upward = true,
      path = fname,
      stop = vim.loop.os_homedir(),
      type = "file",
    })[1]

    if pubspec then
      vim.keymap.set("n", "<F5>", ":Telescope flutter commands<CR>", {
        buffer = args.buf,
        desc = "Flutter commands",
        silent = true,
      })
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dart",
  callback = function()
    vim.keymap.set("n", 'gd', vim.lsp.buf.declaration,
      { buffer = true, desc = 'Type [D]efinition', remap = true })
  end,
})


-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local dart_capabilities = vim.lsp.protocol.make_client_capabilities()
dart_capabilities.textDocument.codeAction = {
  dynamicRegistration = false,
  codeActionLiteralSupport = {
    codeActionKind = {
      valueSet = {
        "",
        "quickfix",
        "refactor",
        "refactor.extract",
        "refactor.inline",
        "refactor.rewrite",
        "source",
        "source.organizeImports",
      },
    },
  },
}
vim.tbl_extend('keep', dart_capabilities, capabilities)

return {
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      { 'j-hui/fidget.nvim',       opts = {} },
      'folke/neodev.nvim',
    },
    config = function()
      local mason_lspconfig = require('mason-lspconfig')
      require('mason').setup()
      mason_lspconfig.setup {
        on_attach = on_attach,
        ensure_installed = {
          'ast_grep',
          'bashls',
          'cssls',
          'eslint',
          'html',
          'jsonls',
          'lua_ls',
          'rust_analyzer',
          'tailwindcss',
          'ts_ls',
        },
        automatic_enable = true,
      }

      require('neodev').setup()

      -- Replace `on_attach` and `capabilities` with your own if needed
      local mason_capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Configure individual servers using new API
      local lsp = vim.lsp

      -- Configurations for servers with custom settings
      local settings = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME, -- helps recognize `vim` global
                  '${3rd}/luv/library',
                  '${3rd}/busted/library',
                },
              },
              telemetry = { enable = false },
              diagnostics = {
                disable = { 'missing-fields' },
                globals = { 'vim' },

              },
            },
          },
        },
        ts_ls = {
          init_options = {
            tsserver = {
              disableSuggestions = true,
            },
          },
        },
        vue_ls = {
          init_options = {
            typescript = {
              tsdk = (function()
                local project_ts = vim.fn.getcwd() .. '/node_modules/typescript/lib'
                if vim.fn.isdirectory(project_ts) == 1 then
                  return project_ts
                else
                  return '' -- fallback: Volar will try global TS
                end
              end)(),
            }
          },
        },
      }

      -- Configure all installed servers using the default settings
      for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
        lsp.config(server, {
          on_attach = on_attach,
          capabilities = mason_capabilities,
        })
      end

      -- Configure servers with custom settings
      for server, config in pairs(settings) do
        lsp.config(server, vim.tbl_deep_extend('force', {
          on_attach = on_attach,
          capabilities = mason_capabilities,
        }, config))
      end
    end,
  },
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = function()
      require('flutter-tools').setup({
        ui = {
          -- the border type to use for all floating windows, the same options/formats
          -- used for ":h nvim_open_win" e.g. "single" | "shadow" | {<table-of-eight-chars>}
          border = "rounded",
          -- This determines whether notifications are show with `vim.notify` or with the plugin's custom UI
          -- please note that this option is eventually going to be deprecated and users will need to
          -- depend on plugins like `nvim-notify` instead.
          -- notification_style = 'native' | 'plugin'
        },
        decorations = {
          statusline = {
            -- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
            -- this will show the current version of the flutter app from the pubspec.yaml file
            app_version = true,
            -- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
            -- this will show the currently running device if an application was started with a specific
            -- device
            device = true,
            -- set to true to be able use the 'flutter_tools_decorations.project_config' in your statusline
            -- this will show the currently selected project configuration
            project_config = true,
          }
        },
        debugger = {           -- integrate with nvim dap + install dart code debugger
          enabled = false,
          run_via_dap = false, -- use dap instead of a plenary job to run flutter apps
          -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
          -- see |:help dap.set_exception_breakpoints()| for more info
          exception_breakpoints = {},
          ---@diagnostic disable-next-line: unused-local
          register_configurations = function(paths)
            require("dap").configurations.dart = {
              -- TODO explore this
              -- NOTE <put here config that you would find in .vscode/launch.json>
            }
          end,
        },
        -- flutter_path = "<full/path/if/needed>", -- <-- this takes priority over the lookup
        -- flutter_lookup_cmd = nil,               -- example "dirname $(which flutter)" or "asdf where flutter"
        -- root_patterns = { ".git", "pubspec.yaml" }, -- patterns to find the root of your flutter project
        -- fvm = true, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
        widget_guides = {
          -- TODO what does this do?
          enabled = false,
        },
        closing_tags = {
          -- highlight = "ErrorMsg", -- highlight for the closing tag
          -- prefix = ">",           -- character to use for close tag e.g. > Widget
          enabled = true -- set to false to disable
        },
        dev_log = {
          enabled = true,
          notify_errors = false, -- if there is an error whilst running then notify the user
          -- open_cmd = "tabedit",  -- command to use to open the log buffer
          open_cmd = "belowright vnew",
          filter = function(line)
            if line == nil then
              return false
            end
            if line:match("^D/EGL") or line:match("^E/libEGL") then
              return false
            end
            return true
          end,
        },
        dev_tools = {
          autostart = false,         -- autostart devtools server if not detected
          auto_open_browser = false, -- Automatically opens devtools in the browser
        },
        outline = {
          open_cmd = "30vnew", -- command to use to open the outline buffer
          auto_open = false    -- if true this will open the outline automatically when it is first populated
        },
        lsp = {
          color = {         -- show the derived colours for dart variables
            enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
            -- background = false, -- highlight the background
            -- background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
            -- foreground = false, -- highlight the foreground
            -- virtual_text = true, -- show the highlight using virtual text
            -- virtual_text_str = "■", -- the virtual text character to highlight
          },
          on_attach = on_attach,
          -- capabilities = dart_capabilities, -- e.g. lsp_status capabilities
          --- OR you can specify a function to deactivate or change or control how the config is created
          capabilities = function(config)
            return vim.tbl_extend('keep', config, dart_capabilities)
          end,
          -- see the link below for details on each option:
          -- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            -- analysisExcludedFolders = { "<path-to-flutter-sdk-packages>" },
            renameFilesWithClasses = "prompt", -- "always"
            enableSnippets = true,
            updateImportsOnRename = true,      -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
          }
        }
      })
    end,
    -- opts = {}
  },
}
