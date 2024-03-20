vim.defer_fn(function()
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local conf = require("telescope.config").values
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"

  local example = function(opts)
    opts = opts or {}

    local function next_color(bufnr)
      actions.move_selection_next(bufnr)
      local selected = action_state.get_selected_entry()
      local cmd = 'colorscheme ' .. selected[1]
      vim.cmd(cmd)
    end

    local function prev_color(bufnr)
      actions.move_selection_previous(bufnr)
      local selected = action_state.get_selected_entry()
      local cmd = 'colorscheme ' .. selected[1]
      vim.cmd(cmd)
    end

    pickers.new(opts, {
      finder = finders.new_table(vim.fn.getcompletion("", "color")),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(bufnr, map)
        actions.select_default:replace(function()
          actions.close(bufnr)
          local selection = action_state.get_selected_entry()
          vim.cmd('colorscheme ' .. selection[1])
        end)

        map("i", "<C-j>", next_color)
        map("i", "<C-k>", prev_color)
        map("i", "<C-n>", next_color)
        map("i", "<C-p>", prev_color)

        return true
      end,
    }):find()
  end


  vim.api.nvim_create_user_command("ColorSchemes", function() example(require("telescope.themes").get_dropdown {}) end,
    { force = true })
end, 100)

return {}
