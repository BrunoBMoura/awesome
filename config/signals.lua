local beautiful = require("beautiful")
local awful = require("awful")

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)

client.connect_signal("manage", function(c)
  if not awesome.startup then awful.client.setslave(c)
    awful.placement.no_offscreen(c)
  end

  if c.maximized then
    c.maximized = false
  end
end)

awesome.connect_signal("switch::keyboard_layout", function()
  KEYBOARD_LAYOUT_WIDGET:switch()
end)

awesome.connect_signal("increase::volume", function()
  VOLUME_WIDGET:increase(5)
end)

awesome.connect_signal("decrease::volume", function()
  VOLUME_WIDGET:decrease(5)
end)

awesome.connect_signal("toggle::control_center", function()
  CONTROL_CENTER:toggle()
end)
