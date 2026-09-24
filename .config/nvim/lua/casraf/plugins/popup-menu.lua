-- Right-click PopUp menu.
--
-- Entries are mode-scoped and Neovim only shows the ones defined for the mode the
-- click happened in, which is what makes the menu selection-aware: `Copy` is Visual
-- only, `Copy Word` / `Select Word` are Normal only.

-- `mousemodel` is "popup_setpos", so this frames the right-click menu. It also
-- covers the builtin completion menu, which nvim-cmp replaces with its own window.
vim.o.pumborder = 'rounded'

--- Menu mode letter -> the keymap mode a `<Plug>` target has to cover. `amenu`
--- routes every other mode through Normal before firing the rhs.
local plug_modes = { a = 'n', n = 'n', v = 'x', i = 'i' }

--- Two cells reserved at the head of every label, so a toggle can show its state
--- without shifting the text.
local UNCHECKED = '  '
local CHECKED = '✓ '

--- Cells between the longest label and its key hint.
local GAP = 2

--- Escape a label for use inside a `:menu` path.
local function escape(label)
  return (label:gsub('[ \\.]', '\\%0'))
end

local function has_lsp()
  return #vim.lsp.get_clients({ bufnr = 0 }) > 0
end

--- A divider. Returns a fresh table per call: each one carries its own menu name.
local function sep() return { separator = true } end

local items = {
  { mode = 'v', label = 'Copy',           keys = 'y' },
  { mode = 'n', label = 'Copy Word',      keys = 'yiw' },
  { mode = 'n', label = 'Copy Line',      keys = 'yy' },
  { mode = 'n', label = 'Copy Paragraph', keys = 'yip' },
  sep(),
  { mode = 'n', label = 'Paste',                 keys = 'p' },
  { mode = 'n', label = 'Paste (Keep register)', keys = 'P' },
  -- `P` over a selection pastes without swallowing the register.
  { mode = 'v', label = 'Paste',                 keys = 'P' },
  { mode = 'i', label = 'Paste',                 keys = '<C-r><C-o>+', hint = '<C-r>+' },
  sep(),
  { mode = 'n', label = 'Select Word',      keys = 'viw' },
  { mode = 'n', label = 'Select Line',      keys = 'V' },
  { mode = 'n', label = 'Select Paragraph', keys = 'vip' },
  sep(),
  {
    mode = 'a',
    label = 'Go To Definition',
    hint = 'gd',
    fn = vim.lsp.buf.definition,
    enabled = has_lsp,
  },
  {
    mode = 'a',
    label = 'Go To References',
    hint = 'gr',
    fn = function() require('fzf-lua').lsp_references() end,
    enabled = has_lsp,
  },
  {
    mode = 'n',
    label = 'Back',
    keys = '<C-t>',
    enabled = function() return vim.fn.gettagstack().curidx > 1 end,
  },
  {
    mode = 'n',
    label = 'Open URL',
    keys = 'gx',
    remap = true,
    enabled = function() return vim.fn.expand('<cfile>'):match('^%a[%w+.-]*://') ~= nil end,
  },
  sep(),
  {
    mode = 'a',
    label = 'Save File',
    hint = '<leader>w',
    fn = function() vim.cmd.write() end,
    enabled = function() return vim.bo.modifiable and vim.bo.buftype == '' end,
  },
  {
    mode = 'a',
    label = 'Format File',
    hint = '=',
    fn = function() require('casraf.lib.custom_formatting').format_manually() end,
  },
  {
    mode = 'a',
    label = 'Auto Format',
    hint = '',
    fn = function() vim.cmd.AutoFormat() end,
    checked = function() return AutoFormatEnabled end,
  },
  sep(),
  {
    mode = 'a',
    label = 'Text Wrap',
    hint = '<leader>z',
    fn = function() vim.wo.wrap = not vim.wo.wrap end,
    checked = function() return vim.wo.wrap end,
  },
  { mode = 'a', label = 'Split Horizontal', hint = '<C-w>s', fn = function() vim.cmd.split() end },
  { mode = 'a', label = 'Split Vertical',   hint = '<C-w>v', fn = function() vim.cmd.vsplit() end },
  sep(),
  {
    mode = 'a',
    label = 'Close Pane',
    hint = 'gq',
    fn = function() vim.cmd.close() end,
    -- On a lone window `:close` takes the whole tab with it, which is Close Tab's
    -- job, so this only offers itself once the tab is actually split. Floats
    -- (noice's cmdline, notifications) are in the window list but are not what
    -- `:close` would act on.
    enabled = function()
      local panes = 0
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(win).relative == '' then
          panes = panes + 1
        end
      end
      return panes > 1
    end,
  },
  -- The tabs along the top are barbar's, and barbar lists buffers rather than tab
  -- pages, so closing "a tab" means closing the buffer behind it.
  {
    mode = 'a',
    label = 'Close Tab',
    hint = '<A-c>',
    fn = function() require('casraf.lib.buffers').close_current() end,
    enabled = function() return vim.bo.buflisted end,
  },
  {
    mode = 'a',
    label = 'Close Tab Page',
    hint = ':tabclose',
    fn = function() vim.cmd.tabclose() end,
    enabled = function() return #vim.api.nvim_list_tabpages() > 1 end,
  },
  { mode = 'a', label = 'Inspect', hint = '', fn = vim.show_pos },
  sep(),
  {
    mode = 'a',
    label = 'Quit Neovim',
    hint = 'gQ',
    fn = function()
      if vim.fn.confirm('Quit Neovim?', '&Yes\n&No', 2) == 1 then
        -- `confirm` so modified buffers still get their own save prompt.
        vim.cmd('confirm qall')
      end
    end,
  },
}

-- Pad every entry to one width so the hints line up flush right in every mode.
local width = 0
for _, item in ipairs(items) do
  if not item.separator then
    item.hint = item.hint or item.keys
    width = math.max(width, #item.label + GAP + #item.hint)
  end
end

--- The `:menu` path for an item, including its current toggle state.
local function name(item)
  local prefix = (item.checked and item.checked()) and CHECKED or UNCHECKED
  local pad = width - #item.label - #item.hint
  return escape(prefix .. item.label .. string.rep(' ', pad) .. item.hint)
end

local cmds = { 'aunmenu PopUp' }

for idx, item in ipairs(items) do
  -- Explicit priorities keep an entry in place when it is re-registered to
  -- redraw its checkmark.
  item.priority = ('500.%d'):format(idx * 10)
  if item.separator then
    item.mode, item.name, item.shown = 'a', ('-Sep%d-'):format(idx), true
    cmds[#cmds + 1] = ('amenu %s PopUp.%s <NOP>'):format(item.priority, item.name)
  else
    item.rhs = item.keys
    -- Menus do not remap by default, which silently drops any `keys` that is
    -- itself a mapping rather than a builtin motion.
    item.verb = item.remap and 'menu' or 'noremenu'
    if item.fn then
      item.rhs = ('<Plug>(popup-menu-%d)'):format(idx)
      vim.keymap.set(plug_modes[item.mode], item.rhs, item.fn, { silent = true, desc = item.label })
      -- `<Plug>` only resolves through the remapping variant.
      item.verb = 'menu'
    end
    item.name = name(item)
    cmds[#cmds + 1] =
        ('%s%s %s PopUp.%s %s'):format(item.mode, item.verb, item.priority, item.name, item.rhs)
  end
end

vim.cmd(table.concat(cmds, '\n'))

-- Clearing Neovim's own group drops its default PopUp handler.
vim.api.nvim_create_augroup('nvim.popupmenu', { clear = true })
local group = vim.api.nvim_create_augroup('nvim_popupmenu', { clear = true })

--- Turn `mode()` into the menu mode letter the entries are registered under.
local function menu_mode()
  local m = vim.fn.mode():sub(1, 1)
  if m:match('[vVs\22\19]') then
    return 'v'
  elseif m == 'i' or m == 'R' then
    return 'i'
  end
  return 'n'
end

local function set_state(item, on)
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, ('%smenu %s PopUp.%s'):format(item.mode, on and 'enable' or 'disable', item.name))
end

vim.api.nvim_create_autocmd('MenuPopup', {
  pattern = '*',
  group = group,
  desc = 'Refresh the context-dependent PopUp entries',
  callback = function()
    local mode = menu_mode()
    local shown = {}

    for _, item in ipairs(items) do
      if item.checked then
        -- A menu entry cannot be renamed, so a changed checkmark means dropping
        -- the entry and re-adding it at the same priority.
        local current = name(item)
        if current ~= item.name then
          ---@diagnostic disable-next-line: param-type-mismatch
          pcall(vim.cmd, ('%sunmenu PopUp.%s'):format(item.mode, item.name))
          item.name = current
          vim.cmd(('%s%s %s PopUp.%s %s'):format(
            item.mode, item.verb, item.priority, item.name, item.rhs))
        end
      end
      if not item.separator then
        shown[item] = (item.mode == 'a' or item.mode == mode)
            and (not item.enabled or item.enabled())
        if item.enabled then
          set_state(item, shown[item])
        end
      end
    end

    -- Neovim hides a disabled entry outright, so a group that emptied out would
    -- leave its dividers stacked up. Keep only dividers that land between two
    -- entries that actually made it into this menu.
    local pending, preceded = nil, false
    for _, item in ipairs(items) do
      if item.separator then
        shown[item] = false
        if preceded then
          pending = item
        end
      elseif shown[item] then
        if pending then
          shown[pending] = true
          pending = nil
        end
        preceded = true
      end
    end

    -- A divider ignores `:menu disable`, so an unwanted one has to leave the menu
    -- outright. Its priority puts it back in place when it returns.
    for _, item in ipairs(items) do
      if item.separator and item.shown ~= shown[item] then
        item.shown = shown[item]
        if item.shown then
          vim.cmd(('amenu %s PopUp.%s <NOP>'):format(item.priority, item.name))
        else
          vim.cmd(('aunmenu PopUp.%s'):format(item.name))
        end
      end
    end
  end,
})

return {}
