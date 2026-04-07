return {
  'chenasraf/input-form.nvim',
  -- dir = vim.fn.expand('~/Dev/input-form.nvim'),
  opts = {},
  keys = {
    {
      '<leader>F',
      function()
        local f = require('input-form')
        local V = f.validators

        local form = f.create_form({
          title = ' Sample Form ',
          inputs = {
            {
              name = 'id',
              label = 'Enter ID',
              type = 'text',
              default = '',
              -- non-empty + at least 3 chars + only [a-zA-Z0-9_-]
              validator = V.chain(
                V.non_empty(),
                V.min_length(3),
                V.matches('^[%w_-]+$', 'Only letters, digits, - and _')
              ),
            },
            {
              name = 'age',
              label = 'Age (number)',
              type = 'text',
              default = '',
              validator = V.chain(V.non_empty(), V.is_number()),
            },
            {
              name = 'terms',
              label = 'Accept terms?',
              type = 'checkbox',
              default = false,
              validator = V.checked(true),
            },
            {
              name = 'choice',
              label = 'Select an option',
              type = 'select',
              default = 'opt1',
              options = {
                { id = 'opt1', label = 'Option 1' },
                { id = 'opt2', label = 'Option 2' },
                { id = 'opt3', label = 'Option 3 (invalid)' },
              },
              -- custom validator: opt3 is rejected
              validator = function(value)
                if value == 'opt3' then
                  return "Option 3 isn't allowed"
                end
              end,
            },
            { type = 'spacer' },
            {
              name = 'body',
              label = 'Enter multiline text',
              type = 'multiline',
              default = 'line one\nline two',
              validator = V.min_length(5, 'Write at least 5 characters'),
            },
          },
          on_submit = function(results)
            vim.notify('Submitted:\n' .. vim.inspect(results), vim.log.levels.INFO)
          end,
          on_cancel = function()
            vim.notify('Cancelled', vim.log.levels.WARN)
          end,
        })
        form:show()
      end,
      desc = 'input-form: show sample form',
    },
  },
}
