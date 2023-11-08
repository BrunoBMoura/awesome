local awful = require("awful")

local autostart = {
  "xrandr --output HDMI-A-0 --rotate right",
  "picom",
  "flameshot",
  USER.portable and "nm-applet" or "systemctl start logid.service",
}

for _, command in ipairs(autostart) do
  awful.spawn.with_shell(command)
end
