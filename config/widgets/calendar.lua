local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Calendar widget module.
local calendar = {}

local function create(screen, color)
  local color = color and color or beautiful.fg_normal

  local clock_widget = wibox.widget.textclock(
    '<span color="' .. color .. '"> %a %b %d, %H:%M </span>'
  )

  local cal_shape = function(cr, width, height)
    gears.shape.rectangle(cr, width, height)
  end

  local month_calendar = awful.widget.calendar_popup.month({
    screen = screen,
    start_sunday = true,
    spacing = dpi(10),
    font = beautiful.font,
    long_weekdays = false,
    margin = dpi(10),
    style_month = {
      border_width = dpi(1), shape = cal_shape, padding = dpi(30)
    }
  })

  -- Attach calentar to clock_widget
  month_calendar:attach(clock_widget, "tc" , {
    on_pressed = true, on_hover = false
  })

  return clock_widget
end

-- Set the __call method to allow calendar() to be called with its necessary arguments.
return setmetatable(calendar, { __call = function(_, ...) return create(...) end })
