local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

-- Utils module.
local utils = {}

-- Invokes a shell command and returns its result as a string to be
-- further matched and processed.
utils.invoke = function(shell_cmd)
  local handle = io.popen(shell_cmd)
  local result = handle:read("*a")
  handle:close()
  return result
end

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
    margin_topbottom = dpi(15)
  })
end

return utils
