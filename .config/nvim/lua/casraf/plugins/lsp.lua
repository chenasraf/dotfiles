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

  local fzf = require('fzf-lua')

  local function goto_declaration_fallback()
    local params = vim.lsp.util.make_position_params(0, 'utf-8')

    -- try definition first
    vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result)
      if not err and result and #result > 0 then
        vim.lsp.util.show_document(result[1], 'utf-8', { focus = true })
      else
        -- fallback for Dart: use references or workspace symbol
        if vim.bo.filetype == 'dart' then
          fzf.lsp_references()
        else
          vim.notify("No definition found", vim.log.levels.WARN)
        end
      end
    end)
  end

  nmap('gd', goto_declaration_fallback, '[G]oto [D]efinition')
  nmap('gr', fzf.lsp_references, '[G]oto [R]eferences')
  nmap('gI', fzf.lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', fzf.lsp_typedefs, 'Type [D]efinition')
  nmap('<leader>ds', fzf.lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', fzf.lsp_live_workspace_symbols, '[W]orkspace [S]ymbols')

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
    require('fzf-lua').fzf_exec(folders, {
      prompt = 'Workspace Folders> ',
      actions = {
        ['default'] = function(selected)
          if selected and selected[1] then
            vim.cmd('cd ' .. selected[1])
          end
        end,
      },
    })
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    local custom_formatting = require("casraf.lib.custom_formatting")
    local format_manually = custom_formatting.format_manually
    format_manually()
  end, { desc = 'Format current buffer with LSP' })
end

local function run_in_terminal(cmd)
  vim.cmd('belowright split | terminal ' .. cmd)
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_create_autocmd('TermClose', {
    buffer = buf,
    once = true,
    callback = function()
      local exit_code = vim.v.event.status
      local msg = exit_code == 0 and 'Done! Press any key to close...' or
          'Failed (exit ' .. exit_code .. '). Press any key to close...'
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then
          vim.bo[buf].modifiable = true
          vim.api.nvim_buf_set_lines(buf, -1, -1, false, { '', msg })
          vim.bo[buf].modifiable = false
          vim.keymap.set('n', '<CR>', ':bd!<CR>', { buffer = buf, silent = true })
          vim.keymap.set('n', 'q', ':bd!<CR>', { buffer = buf, silent = true })
          vim.keymap.set('n', '<Esc>', ':bd!<CR>', { buffer = buf, silent = true })
        end
      end)
    end
  })
end

local function unquote(val)
  local quote = val:sub(1, 1)
  if (quote == '"' or quote == "'") and #val > 1 and val:sub(-1) == quote then
    return val:sub(2, -2)
  end
  return val
end

-- Read .flutter-flags.yml(yaml) from project root for per-command CLI args and
-- extra entries for the <F5> picker.
-- Format:
--   default: --dart-define-from-file=.env
--   FlutterRun: --flavor dev
--   FlutterInstall: --release
--   _Custom:
--     - name: FlutterRunWear
--       label: Run (wear)
--       cmd: ":FlutterRun --flavor wear --debug"
--     - name: InstallWear
--       cmd: "!flutter install --flavor wear"
---@return table<string, string> flags, { name: string, label: string, cmd: string }[] custom
local function read_flutter_flags()
  local flags = {}
  local custom = {}
  for _, name in ipairs({ '.flutter-flags.yml', '.flutter-flags.yaml' }) do
    local path = vim.fn.getcwd() .. '/' .. name
    if vim.fn.filereadable(path) == 1 then
      local in_custom = false
      for _, raw in ipairs(vim.fn.readfile(path)) do
        local indented = raw:match('^%s') ~= nil
        local line = raw:match('^%s*(.-)%s*$')
        if line ~= '' and not line:match('^#') then
          if in_custom and indented then
            local item = line:match('^%-%s*(.*)$')
            if item then
              table.insert(custom, {})
              line = item
            end
            local key, val = line:match('^([%w_%-]+):%s*(.+)$')
            local entry = custom[#custom]
            if key and val and entry then entry[key] = unquote(val) end
          elseif line == '_Custom:' then
            in_custom = true
          else
            in_custom = false
            local key, val = line:match('^([%w_%-]+):%s*(.+)$')
            if key and val then flags[key] = unquote(val) end
          end
        end
      end
      break
    end
  end
  return flags, custom
end

local function get_flutter_args(cmd_name)
  local flags = read_flutter_flags()
  local parts = {}
  if flags.default then table.insert(parts, flags.default) end
  if flags[cmd_name] then table.insert(parts, flags[cmd_name]) end
  local extra = table.concat(parts, ' ')
  return extra ~= '' and (' ' .. extra) or ''
end

-- Swap `{default}` for the `default:` flags, absorbing the surrounding spaces so an
-- unset or placeholder-only `default` leaves no double space behind.
local function expand_default(cmd, default)
  local repl = (default and default ~= '') and (' ' .. default .. ' ') or ' '
  local out = cmd:gsub('%s*{default}%s*', (repl:gsub('%%', '%%%%')))
  return (out:match('^%s*(.-)%s*$'))
end

-- Flutter Ex commands only exist while a dart buffer is current, so switch to one
-- (or open lib/main.dart) before running them.
local function ensure_dart_buffer()
  if vim.bo.filetype == 'dart' then
    return true
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name:match("%.dart$") then
        vim.api.nvim_set_current_buf(buf)
        return true
      end
    end
  end

  local main_dart = vim.fn.getcwd() .. '/lib/main.dart'
  if vim.fn.filereadable(main_dart) == 1 then
    vim.cmd('edit ' .. main_dart)
    return true
  end

  vim.notify("No dart file found", vim.log.levels.WARN)
  return false
end

-- Run a `_Custom` entry. `!cmd` runs in a terminal split, anything else is an
-- Ex command (a leading `:` is optional).
local function run_custom_cmd(cmd)
  local flags = read_flutter_flags()
  cmd = expand_default(cmd, flags.default)
  local shell = cmd:match('^!%s*(.+)$')
  if shell then
    run_in_terminal(shell)
    return
  end
  if not ensure_dart_buffer() then return end
  local ok, err = pcall(vim.cmd, (cmd:gsub('^:', '')))
  if not ok then
    vim.notify('Custom command failed: ' .. tostring(err), vim.log.levels.ERROR)
  end
end

-- Expose each named `_Custom` entry as a buffer-local Ex command, so `:FlutterRunWear`
-- works without going through the picker. Trailing args are appended to the entry's `cmd`.
local function register_custom_commands(buf)
  local _, custom = read_flutter_flags()
  for _, item in ipairs(custom) do
    if item.name and item.cmd then
      -- Vim requires user command names to start uppercase and stay alphanumeric.
      if item.name:match('^%u[%w_]*$') then
        vim.api.nvim_buf_create_user_command(buf, item.name, function(opts)
          local cmd = item.cmd
          if opts.args ~= '' then cmd = cmd .. ' ' .. opts.args end
          run_custom_cmd(cmd)
        end, { nargs = '*', desc = item.label or item.cmd })
      else
        vim.notify_once(
          ('.flutter-flags: "%s" is not a valid command name (must start with an uppercase letter, ' ..
            'then letters/digits/underscores only)'):format(item.name),
          vim.log.levels.WARN)
      end
    end
  end
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
      register_custom_commands(args.buf)

      vim.keymap.set("n", "<F5>", function()
        if not ensure_dart_buffer() then
          return
        end

        local commands = {
          { label = 'Run',                cmd = 'FlutterRun' },
          { label = 'Debug',              cmd = 'FlutterDebug' },
          { label = 'Attach',             cmd = 'FlutterAttach' },
          { label = 'Detach',             cmd = 'FlutterDetach' },
          { label = 'Reload',             cmd = 'FlutterReload' },
          { label = 'Restart',            cmd = 'FlutterRestart' },
          { label = 'Quit',               cmd = 'FlutterQuit' },
          { label = 'Install',            cmd = 'FlutterInstall' },
          { label = 'Devices',            cmd = 'FlutterDevices' },
          { label = 'Emulators',          cmd = 'FlutterEmulators' },
          { label = 'Connect to Device',  cmd = 'FlutterConnectDevice' },
          { label = 'Toggle Outline',     cmd = 'FlutterOutlineToggle' },
          { label = 'Open Outline',       cmd = 'FlutterOutlineOpen' },
          { label = 'Dev Tools',          cmd = 'FlutterDevTools' },
          { label = 'Dev Tools Activate', cmd = 'FlutterDevToolsActivate' },
          { label = 'Copy Profiler URL',  cmd = 'FlutterCopyProfilerUrl' },
          { label = 'Log Toggle',         cmd = 'FlutterLogToggle' },
          { label = 'Log Clear',          cmd = 'FlutterLogClear' },
          { label = 'Rename',             cmd = 'FlutterRename' },
          { label = 'Go to Super',        cmd = 'FlutterSuper' },
          { label = 'Reanalyze',          cmd = 'FlutterReanalyze' },
          { label = 'LSP Restart',        cmd = 'FlutterLspRestart' },
        }

        local labels = {}
        local entries = {}
        local function add(label, entry)
          if label == nil or entries[label] then return end
          table.insert(labels, label)
          entries[label] = entry
        end

        local _, custom = read_flutter_flags()
        local function custom_label(item) return item.label or item.name end
        local function add_custom()
          for _, item in ipairs(custom) do
            if item.cmd then add(custom_label(item), { custom = item.cmd }) end
          end
        end

        -- Project entries sit directly under 'Run', and shadow a built-in of the same name.
        local shadowed = {}
        for _, item in ipairs(custom) do
          local label = custom_label(item)
          if label then shadowed[label] = true end
        end
        for _, item in ipairs(commands) do
          if not shadowed[item.label] then add(item.label, { cmd = item.cmd }) end
          if item.label == 'Run' then add_custom() end
        end
        add_custom()

        require('fzf-lua').fzf_exec(labels, {
          prompt = 'Flutter> ',
          actions = {
            ['default'] = function(selected)
              if selected and selected[1] then
                local entry = entries[selected[1]]
                if not entry then return end
                if entry.custom then
                  run_custom_cmd(entry.custom)
                else
                  vim.cmd(entry.cmd .. get_flutter_args(entry.cmd))
                end
              end
            end,
          },
        })
      end, {
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
      { buffer = true, desc = '[G]oto [D]efinition', remap = true })
    vim.keymap.set("n", 'gD', ':FlutterSuper<CR>',
      { buffer = true, desc = '[G]oto Super Class', silent = true })
    vim.keymap.set("n", '<F2>', ':FlutterRename<CR>',
      { buffer = true, desc = 'Flutter Rename', silent = true })
    vim.keymap.set("n", '<C-A-r>', ':FlutterReload<CR>',
      { buffer = true, desc = 'Flutter Reload', silent = true })
    vim.keymap.set("n", '<C-A-l>', ':FlutterRestart<CR>',
      { buffer = true, desc = 'Flutter Restart', silent = true })
    vim.keymap.set("n", '<leader>rl', ':FlutterReload<CR>',
      { buffer = true, desc = 'Flutter Reload', silent = true })
    vim.keymap.set("n", '<leader>rs', ':FlutterRestart<CR>',
      { buffer = true, desc = 'Flutter Restart', silent = true })
    vim.api.nvim_buf_create_user_command(0, 'FlutterInstall', function(opts)
      local extra = opts.args ~= '' and (' ' .. opts.args) or get_flutter_args('FlutterInstall')
      run_in_terminal('flutter build apk' .. extra .. ' && flutter install' .. extra)
    end, { nargs = '*', desc = 'Build APK and install on device' })

    vim.api.nvim_buf_create_user_command(0, 'FlutterConnectDevice', function()
      local function attempt_connect(octet, port)
        local target = "192.168.68." .. octet .. ":" .. port
        vim.notify("Connecting to " .. target .. "...", vim.log.levels.INFO)
        local stdout_chunks = {}
        local stderr_chunks = {}
        vim.fn.jobstart({ "adb", "connect", target }, {
          stdout_buffered = true,
          stderr_buffered = true,
          on_stdout = function(_, data)
            if data then vim.list_extend(stdout_chunks, data) end
          end,
          on_stderr = function(_, data)
            if data then vim.list_extend(stderr_chunks, data) end
          end,
          on_exit = function(_, exit_code)
            vim.schedule(function()
              local stdout = vim.trim(table.concat(stdout_chunks, "\n"))
              local stderr = vim.trim(table.concat(stderr_chunks, "\n"))
              -- `adb connect` often exits 0 even on failure; inspect output.
              local output_lower = (stdout .. "\n" .. stderr):lower()
              local failed = exit_code ~= 0
                  or output_lower:match("fail")
                  or output_lower:match("cannot connect")
                  or output_lower:match("unable to connect")
                  or output_lower:match("refused")
                  or output_lower:match("error")
              if not failed and output_lower:match("connected to") then
                vim.notify("Successfully connected to " .. target, vim.log.levels.INFO)
                return
              end
              local msg = stdout ~= "" and stdout or stderr
              if msg == "" then msg = "exit code " .. exit_code end
              vim.notify("Connection failed to " .. target .. ": " .. msg, vim.log.levels.ERROR)
              vim.ui.select({ "Retry", "Cancel" }, { prompt = "Connection failed. What would you like to do?" },
                function(choice)
                  if choice == "Retry" then
                    vim.cmd("FlutterConnectDevice")
                  end
                end)
            end)
          end,
        })
      end

      require('input-form').create_form({
        title = ' Connect Android Device ',
        inputs = {
          {
            name = 'port',
            label = 'Device port',
            type = 'text',
          },
          {
            name = 'octet',
            label = 'Device octet (192.168.68.X)',
            type = 'text',
            default = '100',
          },
        },
        on_submit = function(results)
          local octet = results.octet
          local port = results.port
          if octet == nil or octet == '' then
            vim.notify("Octet is required.", vim.log.levels.WARN)
            return
          end
          if port == nil or port == '' then
            vim.notify("Port is required.", vim.log.levels.WARN)
            return
          end
          attempt_connect(octet, port)
        end,
        on_cancel = function()
          vim.notify("Cancelled.", vim.log.levels.INFO)
        end,
      }):show()
    end, { desc = 'Connect to Android device via ADB over TCP/IP' })
  end,
})


-- nvim-cmp supports additional completion capabilities, so broadcast that to servers.
-- This is only the completion branch — `default_capabilities` reads its argument as
-- overrides for that branch rather than as a base to extend, so there is nothing to be
-- gained by seeding it. Nvim fills in the rest, deep-merging this over
-- `make_client_capabilities()` when it starts a client.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- dartls advertises a code action menu built from the kinds it is offered, so the
-- set is pinned here rather than left to the defaults.
local dart_capabilities = vim.deepcopy(capabilities)
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

return {
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      { 'j-hui/fidget.nvim',       opts = {} },
      'folke/neodev.nvim',
      'chenasraf/input-form.nvim',
    },
    config = function()
      require('mason').setup()
      -- What to install lives in mason.lua. `automatic_enable` hooks the registry's
      -- install events, so a server that lands mid-session is enabled without a restart.
      require('mason-lspconfig').setup {
        automatic_enable = true,
      }

      require('neodev').setup()

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

      -- '*' is the base every server's config is merged onto, so a server installed
      -- later in this session picks these up too. Enumerating the installed servers
      -- instead would miss every one of them on a machine's first launch, where the
      -- installs finish long after this runs.
      lsp.config('*', {
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Configure servers with custom settings
      for server, config in pairs(settings) do
        lsp.config(server, config)
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
      -- @type string
      local homedir = vim.loop.os_homedir()

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
          open_cmd = 'botright new',
          filter = function(line)
            if line == nil then
              return false
            end
            if line:match("^D/EGL") or
                line:match("^E/libEGL") or
                ---@diagnostic disable-next-line: param-type-mismatch
                line:match("^flutter: " .. homedir .. "/Library/Containers/") or
                ---@diagnostic disable-next-line: param-type-mismatch
                line:match("^" .. homedir .. "/Library/Containers/") or
                line:match("^I.+Use dataspace")
            then
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
          on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            if vim.lsp.document_color then vim.lsp.document_color.enable(true, { bufnr = bufnr }) end
          end,
          -- capabilities = dart_capabilities, -- e.g. lsp_status capabilities
          --- OR you can specify a function to deactivate or change or control how the config is created
          -- flutter-tools hands its own full capability set in, so the merge has to be
          -- deep and has to let this side win: a shallow one matches on `textDocument`
          -- and drops everything under it, override included.
          capabilities = function(config)
            return vim.tbl_deep_extend('force', config, dart_capabilities)
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
