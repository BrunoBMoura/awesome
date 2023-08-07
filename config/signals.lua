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
end)
