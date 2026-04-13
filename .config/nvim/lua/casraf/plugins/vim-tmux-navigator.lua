vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('tmux-nav-passthrough', { clear = true }),
  pattern = 'lazygit',
  callback = function(ev)
    local directions = { ['<C-h>'] = 'L', ['<C-j>'] = 'D', ['<C-k>'] = 'U', ['<C-l>'] = 'R' }
    for key, dir in pairs(directions) do
      vim.keymap.set({ 'n', 't' }, key, function()
        vim.fn.system('tmux select-pane -' .. dir)
      end, { buffer = ev.buf, nowait = true, silent = true })
    end
  end,
})

return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
  },
}
