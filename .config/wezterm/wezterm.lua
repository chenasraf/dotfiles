-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder({})
end

function unichr(ord)
  if ord == nil then return nil end
  if ord < 32 then return string.format('\\x%02x', ord) end
  if ord < 126 then return string.char(ord) end
  if ord < 65539 then return string.format("\\u%04x", ord) end
  if ord < 1114111 then return string.format("\\u%08x", ord) end
end

-- This is where you actually apply your config choices
config.font = wezterm.font_with_fallback({
  "MesloLGS NF",

  "FiraCode Nerd Font Mono",

  -- <built-in>, BuiltIn
  "JetBrains Mono",

  -- <built-in>, BuiltIn
  -- Assumed to have Emoji Presentation
  -- Pixel sizes: [128]
  "Noto Color Emoji",

  -- <built-in>, BuiltIn
  "Symbols Nerd Font Mono",
})
-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'
-- config.font = wezterm.font("Menlo")
config.font_size = 14.0

config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.enable_tab_bar = false

config.keys = {
  ----------------------------------------------------------------------------------
  --- tmux
  ----------------------------------------------------------------------------------
  -- move between tmux panes: Cmd+Shift+(HJKL) or Cmd+Shift+(Left Down Up Right) Arrow
  { key = "h", mods = "CMD|SHIFT", action = wezterm.action { SendString = "\x02\x1b[D" } },
  { key = "j", mods = "CMD|SHIFT", action = wezterm.action { SendString = "\x02\x1b[B" } },
  { key = "k", mods = "CMD|SHIFT", action = wezterm.action { SendString = "\x02\x1b[A" } },
  { key = "l", mods = "CMD|SHIFT", action = wezterm.action { SendString = "\x02\x1b[C" } },
  { key = "LeftArrow", mods = "CMD|SHIFT", action = wezterm.action { SendString = "\x02\x1b[D" } },
  { key = "DownArrow", mods = "CMD|SHIFT", action = wezterm.action { SendString = "\x02\x1b[B" } },
  { key = "UpArrow", mods = "CMD|SHIFT", action = wezterm.action { SendString = "\x02\x1b[A" } },
  { key = "RightArrow", mods = "CMD|SHIFT", action = wezterm.action { SendString = "\x02\x1b[C" } },
  -- Select window 0-9
  { key = "1", mods = "CMD", action = wezterm.action { SendString = "\x021" } },
  { key = "2", mods = "CMD", action = wezterm.action { SendString = "\x022" } },
  { key = "3", mods = "CMD", action = wezterm.action { SendString = "\x023" } },
  { key = "4", mods = "CMD", action = wezterm.action { SendString = "\x024" } },
  { key = "5", mods = "CMD", action = wezterm.action { SendString = "\x025" } },
  { key = "6", mods = "CMD", action = wezterm.action { SendString = "\x026" } },
  { key = "7", mods = "CMD", action = wezterm.action { SendString = "\x027" } },
  { key = "8", mods = "CMD", action = wezterm.action { SendString = "\x028" } },
  { key = "9", mods = "CMD", action = wezterm.action { SendString = "\x029" } },
  { key = "0", mods = "CMD", action = wezterm.action { SendString = "\x020" } },
  -- Previous/Next tmux window: Cmd+Shift+{/}
  { key = "[", mods = "CMD|SHIFT", action = wezterm.action { SendString = "\x02p" } },
  { key = "]", mods = "CMD|SHIFT", action = wezterm.action { SendString = "\x02n" } },
  -- Zoom - Cmd+Z
  { key = "z", mods = "CMD", action = wezterm.action { SendString = "\x02z" } },
  -- Kill the current pane/last window - Cmd+W
  { key = "w", mods = "CMD", action = wezterm.action { SendString = "\x02x" } },
  -- Detach - Cmd+Shift+W
  { key = "w", mods = "CMD|SHIFT", action = wezterm.action { SendString = "\x02d" } },
  -- Split pane horizontally - Cmd+D
  { key = "d", mods = "CMD", action = wezterm.action { SendString = "\x02|" } },
  -- Split pane vertically - Cmd+Shift+D
  { key = "d", mods = "CMD|SHIFT", action = wezterm.action { SendString = "\x02_" } },
  -- Create new window - Cmd+T
  { key = "t", mods = "CMD", action = wezterm.action { SendString = "\x02c" } },

  ----------------------------------------------------------------------------------
  --- vim
  ----------------------------------------------------------------------------------
  -- move between vim panes: Cmd+(HJKL) or Cmd+(Left Down Up Right) Arrow
  { key = "h", mods = "CMD", action = wezterm.action { SendString = "\x17h" } },
  { key = "j", mods = "CMD", action = wezterm.action { SendString = "\x17j" } },
  { key = "k", mods = "CMD", action = wezterm.action { SendString = "\x17k" } },
  { key = "l", mods = "CMD", action = wezterm.action { SendString = "\x17l" } },
  { key = "LeftArrow", mods = "CMD", action = wezterm.action { SendString = "\x17h" } },
  { key = "DownArrow", mods = "CMD", action = wezterm.action { SendString = "\x17j" } },
  { key = "UpArrow", mods = "CMD", action = wezterm.action { SendString = "\x17k" } },
  { key = "RightArrow", mods = "CMD", action = wezterm.action { SendString = "\x17l" } },

  -- Select all in nvim: Cmd+A
  { key = "a", mods = "CMD", action = wezterm.action { SendString = "\x1bggVG" } },
  -- save in nvim: Cmd+S
  { key = "s", mods = "CMD", action = wezterm.action { SendString = "\x1b\x1b:w\n" } },
  -- save all in nvim: Cmd+Shift+S
  { key = "s", mods = "CMD|SHIFT", action = wezterm.action { SendString = "\x1b\x1b:wa\n" } },
  -- save and cloe pane: Cmd+Opt+S
  { key = "s", mods = "CMD|OPT", action = wezterm.action { SendString = "\x1b\x1bZZ" } },
  -- open file picker in neovim: Cmd+P
  { key = "p", mods = "CMD", action = wezterm.action { SendString = "\x1b\x1b sf\n" } },
  -- Cmd+Shift+P - Select tmux session
  { key = "p", mods = "CMD|SHIFT", action = wezterm.action { SendString = "\x02s" } },

  -- bar bar
  { key = ",", mods = "OPT", action = wezterm.action { SendString = '≤', } },
  { key = ".", mods = "OPT", action = wezterm.action { SendString = '≥', } },
  -- Re-order to previous/next
  { key = ",", mods = "SHIFT|OPT", action = wezterm.action { SendString = '¯', } },
  { key = ".", mods = "SHIFT|OPT", action = wezterm.action { SendString = '˘', } },
  -- Goto buffer in position...
  { key = "1", mods = "OPT", action = wezterm.action { SendString = '¡', } },
  { key = "2", mods = "OPT", action = wezterm.action { SendString = '™', } },
  { key = "3", mods = "OPT", action = wezterm.action { SendString = '£', } },
  { key = "4", mods = "OPT", action = wezterm.action { SendString = '¢', } },
  { key = "5", mods = "OPT", action = wezterm.action { SendString = '∞', } },
  { key = "6", mods = "OPT", action = wezterm.action { SendString = '§', } },
  { key = "7", mods = "OPT", action = wezterm.action { SendString = '¶', } },
  { key = "8", mods = "OPT", action = wezterm.action { SendString = '•', } },
  { key = "9", mods = "OPT", action = wezterm.action { SendString = 'ª', } },
  { key = "0", mods = "OPT", action = wezterm.action { SendString = 'º', } },
  -- Pin/unpin buffer
  { key = "p", mods = "OPT", action = wezterm.action { SendString = 'π', } },
  -- Close buffer
  { key = "c", mods = "OPT", action = wezterm.action { SendString = 'ç', } },
  -- Close all but current
  { key = "c", mods = "SHIFT|OPT", action = wezterm.action { SendString = 'Ç', } },

  ----------------------------------------------------------------------------------
  --- term
  ----------------------------------------------------------------------------------
  -- Delete entire row - Cmd+Backspace
  { key = "Backspace", mods = "CMD", action = wezterm.action { SendString = "\x15" } },
  -- Delete entire word - Opt+Backspace
  { key = "Backspace", mods = "OPT", action = wezterm.action { SendString = "\x17" } },
}

-- and finally, return the configuration to wezterm
return config
