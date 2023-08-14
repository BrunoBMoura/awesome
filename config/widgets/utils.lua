local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Utils module.
local utils = {}

-- Wraps a already existing widget with a underline.
utils.underlined = function(widget, underline_color)
  local underline = wibox.widget {
    widget        = wibox.widget.separator,
    orientation   = "horizontal",
    forced_height = dpi(1),
    forced_width  = dpi(25),
    color         = underline_color,
  }

  return wibox.widget({
    {
      widget,
      layout = wibox.layout.stack,
    },
    {
      underline,
      top = dpi(20),
      layout = wibox.container.margin,
    },
    layout = wibox.layout.stack,
  })
end

-- Creates a tooltip for the given widgets table.
utils.simple_tooltip = function(widgets_tbl, callback)
  awful.tooltip({
    objects = widgets_tbl,
    mode = "outside",
    align = "right",
    timer_function = callback,
    preferred_positions = { "bottom", "center" },
    margin_leftright = dpi(15),
    margin_topbottom = dpi(15),
    border_width = dpi(1),
    border_color = beautiful.border_focus
  })
end

-- Creates a simple textbox widget with default configurations.
utils.simple_textbox = function()
  return wibox.widget({
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    font = beautiful.font
  })
end

return utils
