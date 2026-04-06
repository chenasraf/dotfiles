return {
  -- Highlight, edit, and navigate code
  'chenasraf/nvim-treesitter',
  branch = 'main',
  lazy = false,
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
  },
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {
      install_dir = vim.fn.stdpath('data') .. '/site',
    }

    local ensure_installed = {
      'c', 'cpp', 'go', 'python', 'rust', 'vimdoc', 'vim',
      'lua', 'tsx', 'javascript', 'typescript', 'bash', 'astro', 'css', 'scss',
      'dart', 'json', 'yaml', 'vue',
    }
    local nts = require('nvim-treesitter')
    if type(nts.install) == 'function' then
      pcall(nts.install, ensure_installed)
    else
      -- Older/forked main branch: install via command
      vim.schedule(function()
        pcall(vim.cmd, 'TSInstall! ' .. table.concat(ensure_installed, ' '))
      end)
    end

    -- Register custom filetypes / parser aliases
    vim.filetype.add({ extension = { ejs = 'ejs' } })
    vim.treesitter.language.register('embedded_template', 'ejs')

    vim.filetype.add({
      pattern = {
        ['firestore%.rules'] = 'firestorerules',
        ['storage%.rules'] = 'firestorerules',
        ['.*%.rules'] = {
          priority = -1,
          function(_, bufnr)
            local content = vim.api.nvim_buf_get_lines(bufnr, 0, 5, false)
            for _, line in ipairs(content) do
              if line:match('service%s+cloud%.firestore') or line:match('service%s+firebase%.storage') then
                return 'firestorerules'
              end
            end
          end,
        },
      },
    })
    vim.treesitter.language.register('firestore_rules', 'firestorerules')

    -- Custom Firestore Rules parser registration (main-branch API)
    vim.api.nvim_create_autocmd('User', {
      pattern = 'TSUpdate',
      callback = function()
        require('nvim-treesitter.parsers').firestore_rules = {
          install_info = {
            url = 'https://github.com/grimsteel/tree-sitter-firestore-rules',
            branch = 'main',
            files = { 'src/parser.c' },
          },
        }
      end,
    })

    -- Enable highlighting, indentation, folding via FileType autocmd
    local ts_filetypes = {
      'c', 'cpp', 'go', 'python', 'rust', 'help', 'vim',
      'lua', 'typescriptreact', 'javascript', 'javascriptreact', 'typescript',
      'bash', 'sh', 'zsh', 'astro', 'css', 'scss', 'dart', 'json', 'yaml',
      'ejs', 'firestorerules', 'vue',
    }
    vim.api.nvim_create_autocmd('FileType', {
      pattern = ts_filetypes,
      callback = function(args)
        local ok = pcall(vim.treesitter.start, args.buf)
        if not ok then return end
        -- Indentation (experimental on main), skip for dart
        if vim.bo[args.buf].filetype ~= 'dart' then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- Incremental selection (main branch no longer ships this; reimplement minimally)
    vim.keymap.set('n', '<c-space>', function()
      pcall(vim.cmd, 'normal! v')
    end, { desc = 'TS: init selection (fallback)' })

    -- nvim-treesitter-textobjects (main branch API) — guarded in case the
    -- installed copy hasn't synced to main yet.
    local ok_tobj, tobj = pcall(require, 'nvim-treesitter-textobjects')
    if ok_tobj and type(tobj.setup) == 'function' then
      tobj.setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }

      local function tmap(mode, lhs, mod, fn, arg)
        vim.keymap.set(mode, lhs, function()
          local ok, m = pcall(require, 'nvim-treesitter-textobjects.' .. mod)
          if ok and type(m[fn]) == 'function' then m[fn](arg, 'textobjects') end
        end)
      end

      tmap({ 'x', 'o' }, 'aa', 'select', 'select_textobject', '@parameter.outer')
      tmap({ 'x', 'o' }, 'ia', 'select', 'select_textobject', '@parameter.inner')
      tmap({ 'x', 'o' }, 'af', 'select', 'select_textobject', '@function.outer')
      tmap({ 'x', 'o' }, 'if', 'select', 'select_textobject', '@function.inner')
      tmap({ 'x', 'o' }, 'ac', 'select', 'select_textobject', '@class.outer')
      tmap({ 'x', 'o' }, 'ic', 'select', 'select_textobject', '@class.inner')

      tmap({ 'n', 'x', 'o' }, ']m', 'move', 'goto_next_start', '@function.outer')
      tmap({ 'n', 'x', 'o' }, ']]', 'move', 'goto_next_start', '@class.outer')
      tmap({ 'n', 'x', 'o' }, ']M', 'move', 'goto_next_end', '@function.outer')
      tmap({ 'n', 'x', 'o' }, '][', 'move', 'goto_next_end', '@class.outer')
      tmap({ 'n', 'x', 'o' }, '[m', 'move', 'goto_previous_start', '@function.outer')
      tmap({ 'n', 'x', 'o' }, '[[', 'move', 'goto_previous_start', '@class.outer')
      tmap({ 'n', 'x', 'o' }, '[M', 'move', 'goto_previous_end', '@function.outer')
      tmap({ 'n', 'x', 'o' }, '[]', 'move', 'goto_previous_end', '@class.outer')

      vim.keymap.set('n', '<leader>a', function()
        local ok, swap = pcall(require, 'nvim-treesitter-textobjects.swap')
        if ok then swap.swap_next('@parameter.inner') end
      end)
      vim.keymap.set('n', '<leader>A', function()
        local ok, swap = pcall(require, 'nvim-treesitter-textobjects.swap')
        if ok then swap.swap_previous('@parameter.inner') end
      end)
    end
  end,
}
