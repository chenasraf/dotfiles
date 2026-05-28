-- Bufferline replaces barbar. Mirrors barbar's keybindings and adds
-- filename tinting based on git status (untracked / changed / deleted).
-- Note: filename tinting uses bufferline's `groups` feature, which clusters
-- buffers by status. Tabs of the same git state will appear next to each other.

local tracked_cache = {}

local function is_tracked(path)
  if not path or path == '' or vim.fn.filereadable(path) == 0 then
    return true
  end
  if tracked_cache[path] ~= nil then
    return tracked_cache[path]
  end
  vim.fn.system({ 'git', '-C', vim.fn.fnamemodify(path, ':h'), 'ls-files', '--error-unmatch', path })
  local tracked = vim.v.shell_error == 0
  tracked_cache[path] = tracked
  return tracked
end

local function git_state(bufnr, path)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return nil end
  if not is_tracked(path) then return 'untracked' end
  local ok, dict = pcall(function() return vim.b[bufnr].gitsigns_status_dict end)
  if not ok or not dict then return nil end
  if (dict.removed or 0) > 0 then return 'deleted' end
  if (dict.changed or 0) > 0 or (dict.added or 0) > 0 then return 'changed' end
  return nil
end

return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local function apply_hl()
      local ok, palette = pcall(function() return require('catppuccin.palettes').get_palette() end)
      if not ok then return end
      local set = vim.api.nvim_set_hl
      local tab_bg = palette.mantle
      local active_bg = palette.surface1

      -- Non-group tab backgrounds
      set(0, 'BufferLineBackground', { fg = palette.subtext0, bg = tab_bg })
      set(0, 'BufferLineBufferVisible', { fg = palette.text, bg = tab_bg })
      set(0, 'BufferLineBufferSelected', { fg = palette.text, bg = active_bg, bold = true })

      -- Group buffer-name highlights — fg by status, bg matches tab state
      local function group_hl(name, fg, extra)
        local base = vim.tbl_extend('force', { fg = fg, bold = true }, extra or {})
        set(0, 'BufferLine' .. name, vim.tbl_extend('force', base, { bg = tab_bg }))
        set(0, 'BufferLine' .. name .. 'Visible', vim.tbl_extend('force', base, { bg = tab_bg }))
        set(0, 'BufferLine' .. name .. 'Selected', vim.tbl_extend('force', base, { bg = active_bg }))
      end
      group_hl('C', palette.green)
      group_hl('D', palette.red)
      group_hl('U', palette.sapphire, { italic = true })

      -- Group label pill — dark fg on bright bg
      set(0, 'BufferLineDLabel', { fg = palette.base, bg = palette.red, bold = true })
      set(0, 'BufferLineCLabel', { fg = palette.base, bg = palette.green, bold = true })
      set(0, 'BufferLineULabel', { fg = palette.base, bg = palette.sapphire, bold = true })

      -- Close (X) button — give it the tab bg so it doesn't punch a hole
      set(0, 'BufferLineCloseButton', { fg = palette.overlay0, bg = tab_bg })
      set(0, 'BufferLineCloseButtonVisible', { fg = palette.overlay0, bg = tab_bg })
      set(0, 'BufferLineCloseButtonSelected', { fg = palette.text, bg = active_bg })
      -- Modified (●) indicator
      set(0, 'BufferLineModified', { fg = palette.peach, bg = tab_bg })
      set(0, 'BufferLineModifiedVisible', { fg = palette.peach, bg = tab_bg })
      set(0, 'BufferLineModifiedSelected', { fg = palette.peach, bg = active_bg })

      -- Left-edge indicator slot (kept invisible char-wise, but needs bg to match the tab)
      set(0, 'BufferLineIndicatorSelected', { fg = active_bg, bg = active_bg })
      set(0, 'BufferLineIndicatorVisible', { fg = tab_bg, bg = tab_bg })

    end
    vim.api.nvim_create_autocmd('ColorScheme', { callback = apply_hl })
    apply_hl()

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufFilePost' }, {
      callback = function(ev)
        tracked_cache[ev.file] = nil
        vim.schedule(function() vim.cmd('redrawtabline') end)
      end,
    })
    vim.api.nvim_create_autocmd('User', {
      pattern = 'GitSignsUpdate',
      callback = function() vim.cmd('redrawtabline') end,
    })

    require('bufferline').setup({
      options = {
        mode = 'buffers',
        themable = true,
        numbers = 'none',
        indicator = { style = 'none' },
        color_icons = false,
        close_command = 'bdelete! %d',
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(_, _, diag)
          local s = {}
          if diag.error then table.insert(s, ' ' .. diag.error) end
          if diag.warning then table.insert(s, ' ' .. diag.warning) end
          if diag.hint then table.insert(s, '󰌶 ' .. diag.hint) end
          return table.concat(s, ' ')
        end,
        offsets = {
          { filetype = 'NvimTree', text = 'Files', text_align = 'left', separator = true },
          { filetype = 'neo-tree', text = 'Files', text_align = 'left', separator = true },
        },
        show_buffer_close_icons = true,
        show_close_icon = false,
        separator_style = { '', '' },
        always_show_bufferline = true,
        get_element_icon = function(element)
          local devicons = require('nvim-web-devicons')
          local icon = devicons.get_icon(
            element.path,
            vim.fn.fnamemodify(element.path, ':e'),
            { default = true }
          )
          return icon, nil
        end,
        groups = {
          options = { toggle_hidden_on_enter = true },
          items = {
            require('bufferline.groups').builtin.pinned:with({ icon = '' }),
            -- git state groups: color the filename. NOTE: bufferline's groups
            -- feature reorders buffers — same-status tabs will cluster together.
            {
              name = 'D',
              priority = 2,
              icon = '',
              highlight = { fg = require('catppuccin.palettes').get_palette().red, bold = true },
              matcher = function(buf) return git_state(buf.id, buf.path) == 'deleted' end,
            },
            {
              name = 'C',
              priority = 3,
              icon = '',
              highlight = { fg = require('catppuccin.palettes').get_palette().green, bold = true },
              matcher = function(buf) return git_state(buf.id, buf.path) == 'changed' end,
            },
            {
              name = 'U',
              priority = 4,
              icon = '',
              highlight = { fg = require('catppuccin.palettes').get_palette().sapphire, italic = true, bold = true },
              matcher = function(buf) return git_state(buf.id, buf.path) == 'untracked' end,
            },
          },
        },
      },
    })

    local bl = require('bufferline')
    -- Move to previous/next
    vim.keymap.set({ 'n', 'v' }, '<A-[>', function() bl.cycle(-1) end, { desc = 'Buffer previous' })
    vim.keymap.set({ 'n', 'v' }, '<A-]>', function() bl.cycle(1) end, { desc = 'Buffer next' })
    -- Re-order to previous/next
    vim.keymap.set({ 'n', 'v' }, '<A-{>', function() bl.move(-1) end, { desc = 'Buffer move previous' })
    vim.keymap.set({ 'n', 'v' }, '<A-}>', function() bl.move(1) end, { desc = 'Buffer move next' })
    -- Pin/unpin buffer
    vim.keymap.set('n', '<A-p>', '<Cmd>BufferLineTogglePin<CR>', { desc = 'Buffer toggle pin' })
    -- Close buffer
    vim.keymap.set('n', '<A-c>', '<Cmd>bdelete<CR>', { desc = 'Buffer close' })
    -- Close all but current/pinned
    vim.keymap.set('n', '<A-C>', '<Cmd>BufferLineCloseOthers<CR>', { desc = 'Buffer close others' })
    -- Magic buffer-picking mode
    vim.keymap.set('n', '<C-p>', '<Cmd>BufferLinePick<CR>', { desc = 'Buffer pick' })
  end,
}
