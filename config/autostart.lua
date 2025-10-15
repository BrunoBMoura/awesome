local awful = require("awful")

local autostart = {
  "flameshot",
  "nm-applet",
  -- "picom",
}

for _, command in ipairs(autostart) do
  awful.spawn.with_shell(command)
end
