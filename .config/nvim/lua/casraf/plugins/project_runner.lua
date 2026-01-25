local function create_runner(cmds)
  local function run_cmd(cmd, cmd_type)
    if cmd_type == 'cmd' then
      vim.cmd(cmd)
    elseif cmd_type == 'terminal' then
      vim.cmd('split | wincmd J | resize 20 | terminal ' .. cmd)
    end
  end

  if type(cmds) == 'function' then
    local filename = vim.fn.expand('%:p')
    cmds = cmds(filename)
  end

  local entries = {}
  for _, entry in ipairs(cmds) do
    table.insert(entries, entry.label)
  end

  return function()
    require('fzf-lua').fzf_exec(entries, {
      prompt = 'Select run configuration> ',
      winopts = {
        width = 0.3,
        height = 0.4,
      },
      actions = {
        ['default'] = function(selected)
          if selected and selected[1] then
            for _, cmd_entry in ipairs(cmds) do
              if cmd_entry.label == selected[1] then
                run_cmd(cmd_entry.value, cmd_entry.type or 'terminal')
                break
              end
            end
          end
        end,
      },
    })
  end
end

local function find_package_root()
  -- Find the package.json file directory from the current file's path
  local cmd = 'while [ ! -f package.json ] && [ $(pwd) != "$HOME" ]; do cd ..; done; pwd'
  local pkg_root = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 or not pkg_root then
    print("Not a JS project. Using current working directory")
    return vim.fn.getcwd()
  end
  return string.gsub(pkg_root, "\n$", "")
end

local function get_json_scripts(contents)
  local json = vim.fn.json_decode(contents)
  if not json then
    return {}
  end
  return json.scripts or {}
end

local function js()
  local pkg_root = find_package_root()
  local pkg_file = pkg_root .. '/package.json'
  local lock_file_pnpm = pkg_root .. '/pnpm-lock.yaml'
  local lock_file_yarn = pkg_root .. '/yarn.lock'
  local lock_file_npm = pkg_root .. '/package-lock.json'
  local pnpm_lock_exists = vim.fn.filereadable(lock_file_pnpm) == 1
  local yarn_lock_exists = vim.fn.filereadable(lock_file_yarn) == 1
  local npm_lock_exists = vim.fn.filereadable(lock_file_npm) == 1
  local pkg_manager = pnpm_lock_exists and 'pnpm' or yarn_lock_exists and 'yarn' or npm_lock_exists and 'npm run'
  local file_exists = vim.fn.filereadable(pkg_file) == 1
  if not file_exists or not pkg_manager then
    return {}
  end
  local contents = vim.fn.readfile(pkg_file)
  local scripts = get_json_scripts(contents)
  local cmds = {}
  for name, _ in pairs(scripts) do
    table.insert(cmds, { label = name, value = pkg_manager .. ' ' .. name })
  end
  if #cmds == 0 then
    return {
      { label = 'Start', value = pkg_manager .. ' start' },
      { label = 'Build', value = pkg_manager .. ' build' },
      { label = 'Test',  value = pkg_manager .. ' test' },
    }
  else
    return cmds
  end
end

local type_map = {
  rust = {
    { label = 'Run project',             value = 'cargo run' },
    { label = 'Test project',            value = 'cargo test' },
    { label = 'Build project',           value = 'cargo build' },
    { label = 'Run project (release)',   value = 'cargo run --release' },
    { label = 'Test project (release)',  value = 'cargo test --release' },
    { label = 'Build project (release)', value = 'cargo build --release' },
  },
  typescript = js,
  typescriptreact = js,
  javascript = js,
  javascriptreact = js,
  vue = js,
  lua = function(filename)
    return {
      { label = 'Run file',    value = 'lua ' .. filename,    type = 'cmd' },
      { label = 'Source file', value = 'source ' .. filename, type = 'cmd' },
    }
  end,
}
local group = vim.api.nvim_create_augroup("casraf_project_runner", {})
vim.api.nvim_clear_autocmds({ group = group })

for lang, cmds in pairs(type_map) do
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = lang,
    callback = function()
      vim.keymap.set("n", "<F5>", create_runner(cmds), { buffer = true, desc = "Run commands for" .. lang })
    end,
  })
end

return {}
