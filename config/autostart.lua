local awful = require("awful")

local autostart = USER.portable and {
  -- Notebook options.
  "flameshot",
  "nm-applet",
} or {
  -- Desktop options.
  "xrandr --output HDMI-A-0 --rotate right",
  "picom",
  "flameshot",
  "systemctl start logid.service",
}

for _, command in ipairs(autostart) do
  awful.spawn.with_shell(command)
end
