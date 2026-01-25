vim.defer_fn(function()
  local function color_picker()
    local colors = vim.fn.getcompletion("", "color")
    local original_colorscheme = vim.g.colors_name

    require('fzf-lua').fzf_exec(colors, {
      prompt = 'Colorscheme> ',
      actions = {
        ['default'] = function(selected)
          if selected and selected[1] then
            vim.cmd('colorscheme ' .. selected[1])
          end
        end,
      },
      fzf_opts = {
        ['--preview-window'] = 'hidden',
      },
      fn_transform = function(x) return x end,
      previewer = false,
    })
  end

  vim.api.nvim_create_user_command("ColorSchemes", color_picker, { force = true })
end, 100)

return {}
