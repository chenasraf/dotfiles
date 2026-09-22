-- autoformat.lua
--
-- Switch for controlling whether you want autoformatting.
--  Use :AutoFormat to toggle autoformatting on or off
--
-- The formatting itself lives in format.lua (conform.nvim); this only gates it.

AutoFormatEnabled = true

vim.api.nvim_create_user_command('AutoFormat', function()
  AutoFormatEnabled = not AutoFormatEnabled
  print('Setting autoformatting to: ' .. tostring(AutoFormatEnabled))
end, {})

return {}
