-- nvim-test runner for JS/TS projects that picks vitest when the project has it installed
-- and falls back to nvim-test's jest runner otherwise.
local jest = require('nvim-test.runners.jest')

local build_cmd = jest.build_cmd

local runner = setmetatable({
  config = vim.tbl_deep_extend('force', jest.config, {
    file_pattern = '\\v(__tests__/.*|(spec|test|unit))\\.(js|jsx|coffee|ts|tsx)$',
    find_files = { '{name}.test.{ext}', '{name}.spec.{ext}', '{name}.unit.{ext}' },
  }),
}, { __index = jest })

-- Oil buffers are named `oil:///abs/dir/`; the directory is the project location
local function plain_path(name)
  return (name:gsub('^oil://', ''))
end

-- A suite run has no filename, which would make nvim-test look for package.json from the
-- editor's cwd rather than from the buffer's project
function runner:find_working_directory(filename)
  return jest.find_working_directory(self, plain_path(filename or vim.api.nvim_buf_get_name(0)))
end

local function local_bin(root, name)
  local bin = root .. '/node_modules/.bin/' .. name
  return vim.fn.executable(bin) == 1 and bin or nil
end

-- Browser-mode projects run headless through their own test script; the flag is passed on
-- only when that script uses it
local function runs_headless(root)
  local lines = vim.fn.filereadable(root .. '/package.json') == 1 and vim.fn.readfile(root .. '/package.json') or {}
  return table.concat(lines, '\n'):find('--browser.headless', 1, true) ~= nil
end

-- The terminal job inherits the Node version of the shell nvim was started from, not the one
-- the project pins, and tests that depend on Node internals (fake timers vs. Temporal) behave
-- differently across majors. fnm resolves the pinned version from the project's version file.
local function with_pinned_node(root, cmd)
  local pinned = vim.fn.filereadable(root .. '/.node-version') == 1 or vim.fn.filereadable(root .. '/.nvmrc') == 1
  if not pinned or vim.fn.executable('fnm') ~= 1 then
    return cmd
  end
  return vim.list_extend({ 'fnm', 'exec' }, cmd)
end

function runner:build_cmd(filename, opts)
  -- A directory listing is not a test file, so every run from one is the project's suite
  if filename and filename:find('^oil://') then
    filename = nil
  end

  local root = self:find_working_directory(filename)
  local has_root = root and root ~= ''
  local vitest = has_root and local_bin(root, 'vitest')

  local cmd
  if vitest then
    -- `run` keeps vitest out of watch mode
    cmd = { vitest, 'run' }
    if runs_headless(root) then
      table.insert(cmd, '--browser.headless')
    end
    self:build_args(cmd, filename, opts or {})
  else
    cmd = build_cmd(self, filename, opts)
  end
  return has_root and with_pinned_node(root, cmd) or cmd
end

return runner
