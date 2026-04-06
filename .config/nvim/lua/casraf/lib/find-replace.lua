-- Find/replace forms built on input-form.nvim
local M = {}

local CASE_OPTIONS = {
  { id = "smart", label = "Smart case" },
  { id = "sensitive", label = "Case sensitive" },
  { id = "insensitive", label = "Case insensitive" },
}

local function current_word()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    local saved = vim.fn.getreg("v")
    vim.cmd('noautocmd normal! "vy')
    local sel = vim.fn.getreg("v")
    vim.fn.setreg("v", saved)
    if sel and sel ~= "" and not sel:find("\n") then
      return sel
    end
  end
  local w = vim.fn.expand("<cword>")
  if w and w ~= "" then
    return w
  end
  return ""
end

local function escape_sub(s, delim)
  return (s:gsub("\\", "\\\\"):gsub(delim, "\\" .. delim))
end

local function case_flag(case)
  if case == "sensitive" then
    return "\\C"
  elseif case == "insensitive" then
    return "\\c"
  end
  return ""
end

local function run_current_file(results)
  if results.find == "" then
    vim.notify("find pattern is empty", vim.log.levels.WARN)
    return
  end
  local pat = case_flag(results.case) .. escape_sub(results.find, "/")
  local rep = escape_sub(results.replace, "/")
  local ok, err = pcall(vim.cmd, string.format("%%s/%s/%s/gc", pat, rep))
  if not ok then
    vim.notify(err, vim.log.levels.ERROR)
  end
end

local function run_all_files(results)
  if results.find == "" then
    vim.notify("find pattern is empty", vim.log.levels.WARN)
    return
  end
  local glob = results.pattern
  if glob == "" then
    glob = "**/*"
  end
  local pat = case_flag(results.case) .. escape_sub(results.find, "/")
  local rep = escape_sub(results.replace, "/")
  local ok, err = pcall(vim.cmd, string.format("silent! vimgrep /%s/j %s", pat, glob))
  if not ok then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end
  if vim.fn.getqflist({ size = 0 }).size == 0 then
    vim.notify("no matches for: " .. results.find, vim.log.levels.INFO)
    return
  end
  vim.cmd(string.format("cfdo %%s/%s/%s/gec | update", pat, rep))
  vim.cmd("cfirst")
end

local function build_form(opts)
  local f = require("input-form")
  return f.create_form({
    title = opts.title,
    inputs = {
      {
        name = "find",
        label = "Find",
        type = "text",
        default = opts.find or "",
        validator = f.validators.non_empty(),
      },
      { name = "replace", label = "Replace", type = "text", default = "" },
      { type = "spacer", height = 1 },
      {
        name = "case",
        label = "Case",
        type = "select",
        default = "smart",
        options = CASE_OPTIONS,
      },
      {
        name = "pattern",
        label = "File pattern",
        type = "text",
        default = opts.pattern or "",
      },
    },
    on_submit = opts.on_submit,
  })
end

function M.current_file()
  local file = vim.fn.expand("%:.")
  if file == "" then
    vim.notify("no file for current buffer", vim.log.levels.WARN)
    return
  end
  build_form({
    title = " Find/Replace (current file) ",
    find = current_word(),
    pattern = file,
    on_submit = run_current_file,
  }):show()
end

function M.all_files()
  build_form({
    title = " Find/Replace (all files) ",
    find = current_word(),
    pattern = "**/*",
    on_submit = run_all_files,
  }):show()
end

return M
