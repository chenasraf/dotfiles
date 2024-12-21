local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
    -- hide from tabline
    vim.bo[buf].buflisted = false
  end

  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local function start_insert()
  -- vim.cmd("startinsert")
  vim.defer_fn(function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc><esc>i", true, false, true), "n", true)
  end, 100)
end

local function attach_events(buf, win)
  vim.api.nvim_create_autocmd({ "WinEnter" }, {
    buffer = buf,
    once = true, -- Only trigger this once
    callback = function()
      if vim.api.nvim_get_current_win() == win and vim.bo[buf].buftype == "terminal" then
        start_insert()
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    buffer = buf,
    callback = function()
      if vim.api.nvim_win_is_valid(win) and vim.bo[buf].buftype == "terminal" then
        start_insert()
      end
    end,
  })
end

local function toggle_lazygit()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window({ buf = state.floating.buf })

    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd([[ setlocal nobuflisted | terminal lazygit ]])
      vim.keymap.set({ 'n', 'i', 't' }, 'q', toggle_lazygit, { buffer = state.floating.buf })
    end

    attach_events(state.floating.buf, state.floating.win)
    start_insert()
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

local function setup(opts)
  opts = opts or {}
  vim.api.nvim_create_user_command('LazyGit', toggle_lazygit, { force = true })

  vim.api.nvim_create_autocmd('WinResized', {
    callback = function()
      if not vim.api.nvim_win_is_valid(state.floating.win) then
        return
      end

      vim.api.nvim_win_hide(state.floating.win)
      toggle_lazygit()
    end,
  })
end

local M = {}
M.toggle_lazygit = toggle_lazygit
M.setup = setup
return M
