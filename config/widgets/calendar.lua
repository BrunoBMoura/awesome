local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local calendar = {}

calendar.create = function(screen)
  local clock_widget = wibox.widget.textclock()

  awful.tooltip({
      objects = { clock_widget },
      mode = "outside",
      align = "right",
      timer_function = function()
         return os.date("%x")
      end,
      preferred_positions = { "bottom", "center" },
      margin_leftright = dpi(15),
      margin_topbottom = dpi(15)
  })

  local cal_shape = function(cr, width, height)
      gears.shape.rectangle(cr, width, height)
  end

  local month_calendar = awful.widget.calendar_popup.month({
     screen = screen,
     start_sunday = true,
     spacing = 10,
     font = beautiful.font,
     long_weekdays = false,
     margin = 10, -- 10
     style_month = {border_width = 0, shape = cal_shape, padding = 30},
     --[[ style_header = {border_width = 0, bg_color = "#00000000"},
     style_weekday = {border_width = 0, bg_color = "#00000000"},
     style_normal = {border_width = 0, bg_color = "#00000000"},
     style_focus = {border_width = 0, bg_color = "#8AB4F8"}, ]]
  })

  -- Attach calentar to clock_widget
  month_calendar:attach(clock_widget, "tc" , { on_pressed = true, on_hover = false })

  return clock_widget
end

return calendar
