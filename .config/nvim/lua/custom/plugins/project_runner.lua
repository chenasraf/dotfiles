local function create_runner(cmds)
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local conf = require('telescope.config').values

  local function run_selected(prompt_bufnr, map)
    actions.select_default:replace(function()
      local selection = action_state.get_selected_entry()
      actions.close(prompt_bufnr)
      local value, cmd = unpack(selection.value)
      if value == 'inline' then
        vim.cmd('!' .. cmd)
        return
      elseif value == 'terminal' then
        -- set new split height to 30
        vim.cmd('split | wincmd J | resize 20 | terminal ' .. cmd)
        return
      end
    end)
    return 1
  end
  local items = {}
  if type(cmds) == 'function' then
    cmds = cmds()
  end
  for _, cmd in ipairs(cmds) do
    local label, value = unpack(cmd)
    -- table.insert(items, { label = label, value = { 'inline', value } })
    -- table.insert(items, { label = label .. ' (terminal)', value = { 'terminal', value } })
    table.insert(items, { label = 'Run: ' .. value, label, value = { 'terminal', value } })
  end

  local opts = {
    prompt_title = 'Select run configuration',
    attach_mappings = run_selected,
    layout_config = {
      width = 0.3,
      height = function(_, _, max_lines)
        return math.min(math.floor(max_lines * 0.8), 20)
      end,
    },
    finder = require('telescope.finders').new_table {
      results = items,
      entry_maker = function(entry)
        return {
          value = entry.value,
          display = entry.label,
          ordinal = entry.label,
        }
      end,
    },
  }

  return function()
    require('telescope.pickers').new(opts, {
      sorter = conf.generic_sorter(opts),
    }):find()
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
  local lock_exists = vim.fn.filereadable(lock_file_pnpm) == 1
  local pkg_manager = lock_exists and 'pnpm' or 'yarn'
  local contents = vim.fn.readfile(pkg_file)
  local scripts = get_json_scripts(contents)
  local cmds = {}
  for name, _ in pairs(scripts) do
    table.insert(cmds, { name, pkg_manager .. ' ' .. name })
  end
  if #cmds == 0 then
    return {
      { 'Start', pkg_manager .. ' start' },
      { 'Build', pkg_manager .. ' build' },
      { 'Test',  pkg_manager .. ' test' },
    }
  else
    return cmds
  end
end

local type_map = {
  rust = {
    { 'Run project',             'cargo run' },
    { 'Test project',            'cargo test' },
    { 'Build project',           'cargo build' },
    { 'Run project (release)',   'cargo run --release' },
    { 'Test project (release)',  'cargo test --release' },
    { 'Build project (release)', 'cargo build --release' },
  },
  typescript = js,
  typescriptreact = js,
  javascript = js,
  javascriptreact = js,
}
local group = vim.api.nvim_create_augroup("casraf_project_runner", {})
vim.api.nvim_clear_autocmds({ group = group })

for lang, cmds in pairs(type_map) do
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = lang,
    callback = function()
      vim.keymap.set("n", "<F5>", create_runner(cmds), { buffer = true, desc = "Flutter commands" })
    end,
  })
end

return {}
