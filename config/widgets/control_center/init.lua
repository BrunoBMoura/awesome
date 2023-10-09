local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local slider = require("config.widgets.control_center.audio")

local main_widget = wibox.widget {
  layout = wibox.layout.fixed.vertical,
  spacing = dpi(2),
}

local popup_widget = awful.popup {
  visible = false,
  ontop = true,
  border_width = beautiful.border_width,
  border_color = beautiful.border_color,
  placement = function(d)
    awful.placement.bottom_left(d, { honor_workarea = true, margins = dpi(6) })
  end,
  widget = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.background,
    forced_width = 400,
    {
      widget = wibox.container.margin,
      margins = 20,
      main_widget,
    }
  }
}

awesome.connect_signal("toggle::control_center", function()
  if popup_widget.visible then
    popup_widget.visible = false
  else
    main_widget:reset()
    main_widget:add(slider, slider)
    popup_widget.visible = true
  end
end)
