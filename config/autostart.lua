local awful = require("awful")

local autostart = {
  "flameshot",
  "nm-applet",
  "systemctl start logid.service",
}

for _, command in ipairs(autostart) do
  awful.spawn.with_shell(command)
end
