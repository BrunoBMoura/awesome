local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local colors = beautiful.palette

-- helpers module.
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
M.simple_textbox = function(opts)
  opts = opts or {}
  local font = opts.font or beautiful.font
  return wibox.widget({
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    font = font
  })
end

-- Underlines a given widget.
M.underlined = function(widget, underline_color)
  local underline = wibox.widget({
    widget        = wibox.widget.separator,
    orientation   = "horizontal",
    forced_height = dpi(1),
    forced_width  = dpi(25),
    color         = underline_color,
  })

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

-- Creates a box for the given widget.
M.box = function(widget, opts)
  opts = opts or {}
  local fg = opts.foreground_color or beautiful.fg_normal
  local bg = opts.background_color or beautiful.bg_normal
  local margin = opts.margin or dpi(5)
  local radius = opts.radius or dpi(5)
  local shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end

  return wibox.widget({
    {
      widget,
      bg = bg,
      fg = fg,
      -- shape = shape,
      widget = wibox.container.background
    },
    margins = margin,
    widget = wibox.container.margin
  })
end

-- Creates an arc widget with a text box inside it.
M.arc = function(bg, thickness, text)
  local text_box = M.simple_textbox({ font = USER.font(20) })
  text_box:set_text(string.format("%s%s", text, "0%" ))

  return wibox.widget({
    text_box,
    id = "text",
    max_value = 100,
    min_value = 0,
    thickness = thickness,
    start_angle = 4.71238898, -- 2pi*3/4
    forced_height = dpi(150),
    forced_width = dpi(150),
    border_width = dpi(1),
    border_color = bg,
    bg = bg,
    colors = { USER.palette.grey },
    widget = wibox.container.arcchart
  })
end

-- Creates an slider widget for ui controls. It also provides a simple
-- single method on it for its value update.
M.slider_widget = function(text_icon, color)
  local slider = wibox.widget({
    widget = wibox.widget.slider,
    maximum = 100,
    forced_height = dpi(10),
    bar_height = dpi(2),
    bar_color = color,
    handle_width = dpi(30),
    handle_border_width = dpi(5),
    handle_margins = { top = dpi(1), bottom = dpi(1) },
    handle_shape = gears.shape.square,
    handle_color = colors.white,
    handle_border_color = colors.grey,
  })

  local icon = wibox.widget({
    widget = wibox.widget.textbox,
    markup = text_icon,
    align = "center",
    font = USER.font(15),
  })

  local percentage = wibox.widget({
    widget = wibox.widget.textbox,
    align = "center",
  })

  local final_widget = wibox.widget({
    layout = wibox.layout.fixed.horizontal,
    fill_space = true,
    spacing = dpi(1),
    icon,
    {
      slider,
      widget = wibox.container.background,
      forced_width = dpi(380),
      forced_height = dpi(25)
    },
    percentage
  })

  final_widget.set_value = function(_, value)
    slider.value = value
    percentage.markup = value .. "%"
  end

  return final_widget
end

M.button = function(opts)
  opts = opts or {}
  local text = opts.text or "Button"
  local bg = opts.background_color or beautiful.background_alt
  local fg = opts.foreground_color or beautiful.fg_normal

  local widget = wibox.widget({
    widget = wibox.container.background,
    bg = bg,
    fg = fg,
    {
      widget = wibox.widget.textbox,
      text = text ,
      font = USER.font(15),
    }
  })

  return widget
end
return M
