local M = {}

local MARKER = "DEBUG"

-- Each template gets the variable name and must return the full log line
-- (without indentation or comment marker — both are added by the caller).
-- `comment` is the line-comment prefix used to tag the inserted line so the
-- cleanup command can find it later.
local templates = {
  bash            = { log = function(v) return string.format('echo "%s: $%s"', v, v) end, comment = "#" },
  c               = { log = function(v) return string.format('printf("%s: %%d\\n", %s);', v, v) end, comment = "//" },
  cpp             = { log = function(v) return string.format('std::cout << "%s: " << %s << std::endl;', v, v) end, comment = "//" },
  dart            = { log = function(v) return string.format("debugPrint('%s: $%s');", v, v) end, comment = "//" },
  elixir          = { log = function(v) return string.format('IO.inspect(%s, label: "%s")', v, v) end, comment = "#" },
  fish            = { log = function(v) return string.format('echo "%s: $%s"', v, v) end, comment = "#" },
  go              = { log = function(v) return string.format('fmt.Println("%s:", %s)', v, v) end, comment = "//" },
  java            = { log = function(v) return string.format('System.out.println("%s: " + %s);', v, v) end, comment = "//" },
  javascript      = { log = function(v) return string.format("console.debug('%s:', %s)", v, v) end, comment = "//" },
  javascriptreact = { log = function(v) return string.format("console.debug('%s:', %s)", v, v) end, comment = "//" },
  kotlin          = { log = function(v) return string.format('println("%s: $%s")', v, v) end, comment = "//" },
  lua             = { log = function(v) return string.format("print('%s:', %s)", v, v) end, comment = "--" },
  php             = { log = function(v) return string.format('error_log("%s: " . print_r($%s, true));', v, v) end, comment = "//" },
  python          = { log = function(v) return string.format("print(f'%s: {%s}')", v, v) end, comment = "#" },
  ruby            = { log = function(v) return string.format('puts "%s: #{%s}"', v, v) end, comment = "#" },
  rust            = { log = function(v) return string.format("dbg!(%s);", v) end, comment = "//" },
  sh              = { log = function(v) return string.format('echo "%s: $%s"', v, v) end, comment = "#" },
  svelte          = { log = function(v) return string.format("console.debug('%s:', %s)", v, v) end, comment = "//" },
  swift           = { log = function(v) return string.format('debugPrint("%s: \\(%s)")', v, v) end, comment = "//" },
  typescript      = { log = function(v) return string.format("console.debug('%s:', %s)", v, v) end, comment = "//" },
  typescriptreact = { log = function(v) return string.format("console.debug('%s:', %s)", v, v) end, comment = "//" },
  vue             = { log = function(v) return string.format("console.debug('%s:', %s)", v, v) end, comment = "//" },
  zsh             = { log = function(v) return string.format('echo "%s: $%s"', v, v) end, comment = "#" },
}

local function get_template()
  local ft = vim.bo.filetype
  return templates[ft], ft
end

local function get_variable(mode)
  if mode == "v" then
    local save = vim.fn.getreg('"')
    vim.cmd('noautocmd silent normal! gvy')
    local sel = vim.fn.getreg('"')
    vim.fn.setreg('"', save)
    -- Strip surrounding whitespace / newlines.
    sel = sel:gsub("^%s+", ""):gsub("%s+$", "")
    if sel == "" then return nil end
    return sel
  end
  local word = vim.fn.expand("<cword>")
  if word == "" then return nil end
  return word
end

function M.insert(mode)
  local tmpl, ft = get_template()
  if not tmpl then
    vim.notify("debug_log: no template for filetype '" .. ft .. "'", vim.log.levels.WARN)
    return
  end

  local var = get_variable(mode)
  if not var then
    vim.notify("debug_log: no variable under cursor/selection", vim.log.levels.WARN)
    return
  end

  local row = vim.api.nvim_win_get_cursor(0)[1]
  local current = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
  local indent = current:match("^(%s*)") or ""

  local line = string.format("%s%s %s %s", indent, tmpl.log(var), tmpl.comment, MARKER)
  vim.api.nvim_buf_set_lines(0, row, row, false, { line })
end

function M.clear()
  local tmpl, ft = get_template()
  if not tmpl then
    vim.notify("debug_log: no template for filetype '" .. ft .. "'", vim.log.levels.WARN)
    return
  end

  local pattern = vim.pesc(tmpl.comment) .. "%s+" .. MARKER .. "%s*$"
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local kept, removed = {}, 0
  for _, l in ipairs(lines) do
    if l:find(pattern) then
      removed = removed + 1
    else
      table.insert(kept, l)
    end
  end

  if removed == 0 then
    vim.notify("debug_log: no marked lines found", vim.log.levels.INFO)
    return
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, kept)
  vim.notify(string.format("debug_log: removed %d line%s", removed, removed == 1 and "" or "s"), vim.log.levels.INFO)
end

function M.setup()
  vim.keymap.set("n", "<leader>cl", function() M.insert("n") end,
    { desc = "Insert debug log for word under cursor", silent = true })
  vim.keymap.set("v", "<leader>cl", function() M.insert("v") end,
    { desc = "Insert debug log for selection", silent = true })
  vim.keymap.set("n", "<leader>cL", M.clear,
    { desc = "Remove all debug logs in buffer", silent = true })

  vim.api.nvim_create_user_command("DebugLog", function() M.insert("n") end,
    { nargs = 0, desc = "Insert debug log for word under cursor" })
  vim.api.nvim_create_user_command("DebugLogClear", M.clear,
    { nargs = 0, desc = "Remove all debug logs in buffer" })
end

return M
