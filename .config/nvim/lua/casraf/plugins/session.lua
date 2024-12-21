local function simple_hash(input)
  -- Convert the input string to a basic hash
  local hash = 0
  for i = 1, #input do
    local char = input:byte(i)
    hash = (hash * 31 + char) % 2 ^ 32
  end

  -- Convert the hash to a string using base64-like encoding
  local base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
  local result = ""
  repeat
    local index = (hash % 64) + 1
    result = base64_chars:sub(index, index) .. result
    hash = math.floor(hash / 64)
  until hash == 0

  return result
end

local group = vim.api.nvim_create_augroup('mksession', { clear = true })

local function get_session_file()
  local wd = vim.fn.getcwd()
  local md5 = simple_hash(wd)
  local sess_dir = vim.fn.stdpath('data') .. '/sessions/'
  local sess_file = sess_dir .. md5 .. '.vim'

  return sess_file
end

local function save_session()
  local sess_file = get_session_file()
  vim.cmd('mksession! ' .. sess_file)
  print('Session saved to ' .. sess_file)
end

local function load_session()
  local sess_file = get_session_file()
  if vim.fn.filereadable(sess_file) == 1 then
    vim.cmd('source ' .. sess_file)
    print('Session loaded from ' .. sess_file)
  end
end

vim.api.nvim_create_user_command('SessionSave', save_session, { nargs = 0, force = true })
vim.api.nvim_create_user_command('SessionLoad', load_session, { nargs = 0, force = true })

vim.api.nvim_create_autocmd('VimLeavePre', {
  pattern = "*",
  group = group,
  callback = save_session,
})

vim.api.nvim_create_autocmd('VimEnter', {
  pattern = "*",
  group = group,
  callback = load_session,
})


return {}
