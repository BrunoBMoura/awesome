local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi
local utils = {}

utils.underlined = function(widget, underline_color --[[, underline_height]])
  local underline = wibox.widget {
    widget        = wibox.widget.separator,
    orientation   = "horizontal",
    -- forced_height = dpi(1),
    forced_width  = dpi(25),
    color         = underline_color,
  }

  local wrapper = wibox.widget({
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

  return wrapper
end

return utils

