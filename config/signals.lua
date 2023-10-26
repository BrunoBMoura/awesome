local beautiful = require("beautiful")

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
  keyboard_layout_widget:switch()
end)

awesome.connect_signal("increase::volume", function()
  volume_widget:increase(5)
end)

awesome.connect_signal("decrease::volume", function()
  volume_widget:decrease(5)
end)

awesome.connect_signal("toggle::control_center", function()
  control_center:toggle()
end)
