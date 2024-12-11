local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values
local sorters = require("telescope.sorters")

local M = {}

local live_multigrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.fn.getcwd()
  -- opts.find_command = opts.find_command or { "rg", "--hidden", "-g", "!.git", "-g", "!node_modules" }

  local finder = finders.new_async_job({
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local pieces = vim.split(prompt, "  ")
      local args = { "rg", "--hidden", "-g", "!.git", "-g", "!node_modules" }

      if pieces[1] then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      end

      -- return vim.iter(
      --   args,
      --   { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }
      -- ):flatten():totable()

      ---@diagnostic disable-next-line: deprecated
      return vim.tbl_flatten({
        args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
      })
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  })

  pickers.new(opts, {
    prompt_title = "Live Multigrep",
    finder = finder,
    debounce = 400,
    previewer = conf.grep_previewer(opts),
    sorter = sorters.empty(),
  }):find()
end

M.live_multigrep = live_multigrep

return M
