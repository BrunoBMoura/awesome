local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Utils module.
local M = {}

-- Notifies the given text.
M.notify = function(text)
  local info = debug.getinfo(1, "Sl")
  naughty.notify({
    title = "::Assert::",
    text = string.format(
      "Called from (%s, %s): %s", info.short_src, info.currentline, tostring(text)
    )
  })
end

-- Builds a match string for the given number of occurrences or numerical values.
M.build_match_for = function(occurrences)
  local match = "(%d+)"
  for _ = 1, occurrences - 1 do
    match = match .. "%s+(%d+)"
  end
  return match
end

-- Colorizes the given widget with the given colors.
M.colorize = function(widget, foreground_color, background_color)
  local fg = foreground_color or beautiful.fg_normal
  local bg = background_color or beautiful.bg_normal
  return wibox.widget({
    {
      widget,
      bg = bg,
      fg = fg,
      widget = wibox.container.background
    },
    layout = wibox.layout.fixed.horizontal
  })
end

-- Creates a tooltip for the given widgets table.
M.simple_tooltip = function(widgets_tbl, callback)
  awful.tooltip({
    objects = widgets_tbl,
    mode = "outside",
    align = "right",
    timer_function = callback,
    preferred_positions = { "bottom", "center" },
    margin_leftright = dpi(15),
    margin_topbottom = dpi(15),
    border_width = dpi(1),
    bg = beautiful.bg_normal,
  })
end

-- Creates a simple textbox widget with default configurations.
M.simple_textbox = function()
  return wibox.widget({
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    font = beautiful.font
  })
end

M.underlined = function(widget, underline_color)
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
      top = dpi(28),
      layout = wibox.container.margin,
    },
    layout = wibox.layout.stack,
  })
end

return M
