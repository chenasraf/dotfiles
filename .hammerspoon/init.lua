-- Auto-switch AeroSpace layout based on external monitor presence.
--
--   1 screen  -> accordion         (stack windows; usable on the small laptop display)
--   2+ screens -> tiles horizontal  (spread out across the wide external monitor)
--
-- AeroSpace has no monitor connect/disconnect callback and no per-monitor
-- default layout, so we watch macOS display changes here and drive the
-- `aerospace` CLI. `layout ... --window-id` sets a window's container layout
-- without stealing focus.

local aerospace = "/opt/homebrew/bin/aerospace"

-- Apps that have an AeroSpace `on-window-detected` floating rule. Never retile
-- these -- passing a tiling layout to a floating window would un-float it.
local floatingApps = {
  ["com.DanPristupov.Fork"] = true,
}

local function applyLayout()
  local layout = (#hs.screen.allScreens() >= 2) and "tiles horizontal" or "accordion"

  local out, ok = hs.execute(aerospace .. " list-windows --all --format '%{window-id}|%{app-bundle-id}'")
  if not ok or not out then return end

  for id, bundle in out:gmatch("(%d+)|(%S+)") do
    if not floatingApps[bundle] then
      hs.execute(aerospace .. " layout " .. layout .. " --window-id " .. id)
    end
  end
end

-- Fires on any display reconfiguration (plug/unplug, arrangement change).
screenWatcher = hs.screen.watcher.new(applyLayout)
screenWatcher:start()

-- Apply once on load so the layout is correct at login / config reload.
applyLayout()
