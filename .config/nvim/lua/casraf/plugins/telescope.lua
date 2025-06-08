return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-media-files.nvim' },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`

      local builtin = require('telescope.builtin')

      -- Telescope live_grep in git root
      -- Function to find the git root directory based on the current buffer's path
      local function find_git_root()
        -- Use the current buffer's path as the starting point for the git search
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_dir = ""
        local cwd = vim.fn.getcwd()
        -- If the buffer is not associated with a file, return nil
        if current_file == "" then
          current_dir = cwd or ""
        else
          -- Extract the directory from the current file's path
          current_dir = vim.fn.fnamemodify(current_file, ":h") or ""
        end

        -- Find the Git root directory from the current file's path
        local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")
            [1]
        if vim.v.shell_error ~= 0 then
          print("Not a git repository. Searching on current working directory")
          return cwd
        end
        return git_root
      end

      -- Custom live_grep function to search in git root
      local function live_grep_git_root()
        local git_root = find_git_root()
        require('casraf.lib.telescope_multigrep').live_multigrep({
          cwd = { git_root },
        })
      end

      vim.defer_fn(function()
        -- See `:help telescope.builtin`
        vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
        vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
        vim.keymap.set('n', '<leader>/', function()
          -- You can pass additional configuration to telescope to change theme, layout, etc.
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end, { desc = '[/] Fuzzily search in current buffer' })

        vim.keymap.set('n', '<leader>sR', function()
          local term = vim.ui.input('Grep File Contents (regex) ⟩ ')
          if term == '' then
            return
          end
          builtin.grep_string({ search = term, use_regex = true })
        end)

        local action_layout = require("telescope.actions.layout")
        local actions = require("telescope.actions")

        vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = '[F]ind [G]it [F]iles', silent = true })
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles', silent = true })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp', silent = true })
        vim.keymap.set({ 'n', 'v' }, '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord', silent = true })
        vim.keymap.set('n', '<leader>fg', require('casraf.lib.telescope_multigrep').live_multigrep,
          { desc = '[F]ind by [G]rep', silent = true })
        vim.keymap.set('n', '<leader>fG', live_grep_git_root, { desc = '[F]ind by [G]rep on Git Root', silent = true })
        vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics', silent = true })
        vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume', silent = true })
        vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps', silent = true })
        vim.keymap.set('n', '<leader>ft', "<Cmd>Telescope<CR>", { desc = '[F]ind [T]elescope Pickers', silent = true })
        vim.keymap.set('n', '<leader>fq', "<Cmd>Telescope quickfix<CR>", { desc = '[F]ind [Q]uickfix', silent = true })
        vim.keymap.set('n', '<leader>fn', '<Cmd>NoiceTelescope<CR>', { desc = '[F]ind [N]otifications', silent = true })
        vim.keymap.set('n', '<leader>fp', function()
          builtin.find_files({
            prompt_title = 'Find Package Files',
            -- cwd = vim.fs.joinpath(vim.fn.getcwd(), 'node_modules'),
            cwd = vim.fn.getcwd(),
            find_command = { 'rg', '--files', '--no-ignore', '--hidden', '-g', '**/node_modules/**' },
            file_ignore_patterns = {},
          })
        end, { desc = '[F]ind [P]ackage Files', silent = true })
        vim.keymap.set('n', '<leader>fP', function()
          builtin.find_files({
            prompt_title = 'Find Plugins',
            ---@diagnostic disable-next-line: param-type-mismatch
            cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
          })
        end, { desc = '[F]ind [P]lugins', silent = true })
        vim.keymap.set('n', '<leader>f.', function()
          builtin.find_files({
            prompt_title = 'Find Dotfiles',
            cwd = os.getenv('DOTFILES'),
          })
        end, { desc = '[F]ind [.]dotfiles', silent = true })
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'media_files')
        require('telescope').setup {
          defaults = {
            mappings = {
              i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
                ['<C-h>'] = 'which_key',
                ['<C-p>'] = action_layout.toggle_preview

              },
              n = {
                ['<M-q>'] = false,
                ['<C-q>'] = actions.add_selected_to_qflist + actions.open_qflist,
                ['<C-p>'] = action_layout.toggle_preview

              },
            },
            file_ignore_patterns = {
              "node_modules"
            },
            vimgrep_arguments = {
              'rg',
              '--color=never',
              '--no-heading',
              '--with-filename',
              '--line-number',
              '--column',
              '--smart-case',
              '--hidden',
              '-g', '!.git',
              '-g', '!node_modules'
            },
            preview = {
              mime_hook = function(filepath, bufnr, opts)
                local is_image = function(fp)
                  local image_extensions = { 'png', 'jpg', 'jpeg', 'gif' } -- Supported image formats
                  local split_path = vim.split(fp:lower(), '.', { plain = true })
                  local extension = split_path[#split_path]
                  return vim.tbl_contains(image_extensions, extension)
                end
                if is_image(filepath) then
                  local term = vim.api.nvim_open_term(bufnr, {})
                  local function send_output(_, data, _)
                    for _, d in ipairs(data) do
                      vim.api.nvim_chan_send(term, d .. '\r\n')
                    end
                  end
                  vim.fn.jobstart(
                    { 'catimg', filepath }, -- Terminal image viewer command
                    { on_stdout = send_output, stdout_buffered = true, pty = true })
                else
                  require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid,
                    "Binary cannot be previewed")
                end
              end
            },
          },
          extensions = {
            media_files = {
              -- filetypes = { "png", "webp", "jpg", "jpeg", "svg", "gif", "mp4", "webm", "pdf" },
              filetypes = { 'png', 'jpg', 'jpeg', 'gif' },
              -- find command (defaults to `fd`)
              find_cmd = "rg"
            },
          },
          pickers = {
            find_files = {
              find_command = { 'rg', '--files', '--hidden', '-g', '!.git', '-g', '!node_modules' },
            },
          },
        }
      end, 0)
    end
  },
  {
    'chenasraf/telescope-glyph.nvim',
    config = function()
      require('telescope').load_extension('glyph')
      vim.keymap.set('n', '<leader>fc', '<Cmd>Telescope glyph<CR>', { desc = '[F]ind [G]lyphs' })
    end,
  },
  {
    'xiyaowong/telescope-emoji.nvim',
    config = function()
      require('telescope').load_extension('emoji')
      vim.keymap.set('n', '<leader>fe', '<Cmd>Telescope emoji<CR>', { desc = '[F]ind [E]mojis' })
    end,
  }
}
