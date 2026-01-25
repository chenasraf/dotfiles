local function find_git_root()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir = ""
  local cwd = vim.fn.getcwd()
  if current_file == "" then
    current_dir = cwd or ""
  else
    current_dir = vim.fn.fnamemodify(current_file, ":h") or ""
  end

  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local fzf = require('fzf-lua')

      fzf.setup({
        winopts = {
          preview = {
            default = 'bat',
          },
        },
        keymap = {
          builtin = {
            ['<C-p>'] = 'toggle-preview',
          },
          fzf = {
            ['ctrl-q'] = 'select-all+accept',
          },
        },
        files = {
          cmd = 'rg --files --hidden -g "!.git" -g "!node_modules"',
        },
        grep = {
          rg_opts = '--color=never --no-heading --with-filename --line-number --column --smart-case --hidden -g "!.git" -g "!node_modules"',
        },
      })

      vim.defer_fn(function()
        -- Basic mappings
        vim.keymap.set('n', '<leader>?', fzf.oldfiles, { desc = '[?] Find recently opened files' })
        vim.keymap.set('n', '<leader><space>', fzf.buffers, { desc = '[ ] Find existing buffers' })
        vim.keymap.set('n', '<leader>/', function()
          fzf.blines({ winopts = { preview = { hidden = 'hidden' } } })
        end, { desc = '[/] Fuzzily search in current buffer' })

        -- File/Grep mappings
        vim.keymap.set('n', '<leader>ff', fzf.files, { desc = '[F]ind [F]iles', silent = true })
        vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = '[F]ind by [G]rep', silent = true })
        vim.keymap.set('n', '<leader>fG', function()
          fzf.live_grep({ cwd = find_git_root() })
        end, { desc = '[F]ind by [G]rep on Git Root', silent = true })
        vim.keymap.set('n', '<leader>fh', fzf.helptags, { desc = '[F]ind [H]elp', silent = true })
        vim.keymap.set({ 'n', 'v' }, '<leader>fw', fzf.grep_cword, { desc = '[F]ind current [W]ord', silent = true })
        vim.keymap.set('n', '<leader>fd', fzf.diagnostics_document, { desc = '[F]ind [D]iagnostics', silent = true })
        vim.keymap.set('n', '<leader>fr', fzf.resume, { desc = '[F]ind [R]esume', silent = true })
        vim.keymap.set('n', '<leader>fk', fzf.keymaps, { desc = '[F]ind [K]eymaps', silent = true })
        vim.keymap.set('n', '<leader>ft', fzf.builtin, { desc = '[F]ind fzf-lua Pickers', silent = true })
        vim.keymap.set('n', '<leader>fq', fzf.quickfix, { desc = '[F]ind [Q]uickfix', silent = true })
        vim.keymap.set('n', '<leader>fn', '<Cmd>Noice fzf<CR>', { desc = '[F]ind [N]otifications', silent = true })

        -- Special file locations
        vim.keymap.set('n', '<leader>fp', function()
          fzf.files({
            prompt = 'Find Package Files> ',
            cwd = vim.fn.getcwd(),
            cmd = 'rg --files --no-ignore --hidden -g "**/node_modules/**"',
          })
        end, { desc = '[F]ind [P]ackage Files', silent = true })

        vim.keymap.set('n', '<leader>fP', function()
          fzf.files({
            prompt = 'Find Plugins> ',
            ---@diagnostic disable-next-line: param-type-mismatch
            cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy'),
          })
        end, { desc = '[F]ind [P]lugins', silent = true })

        vim.keymap.set('n', '<leader>f.', function()
          fzf.files({
            prompt = 'Find Dotfiles> ',
            cwd = os.getenv('DOTFILES'),
          })
        end, { desc = '[F]ind [.]dotfiles', silent = true })
      end, 0)
    end,
  },
  {
    'ziontee113/icon-picker.nvim',
    dependencies = { 'stevearc/dressing.nvim' },
    config = function()
      require('icon-picker').setup({
        disable_legacy_commands = true,
      })
      vim.keymap.set('n', '<leader>fc', '<Cmd>IconPickerNormal<CR>', { desc = '[F]ind [G]lyphs' })
      vim.keymap.set('n', '<leader>fe', '<Cmd>IconPickerNormal emoji<CR>', { desc = '[F]ind [E]mojis' })
      vim.keymap.set('i', '<C-i>', '<Cmd>IconPickerInsert<CR>', { desc = 'Insert Icon' })
    end,
  },
}
