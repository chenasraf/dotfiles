return {
  'chenasraf/input-form.nvim',
  keys = {
    {
      '<leader>sr',
      function() require('casraf.lib.find-replace').current_file() end,
      mode = { 'n', 'v' },
      desc = 'Find/Replace (current file)',
    },
    {
      '<leader>sR',
      function() require('casraf.lib.find-replace').all_files() end,
      mode = { 'n', 'v' },
      desc = 'Find/Replace (all files)',
    },
  },
}
