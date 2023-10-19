local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("config.widgets.helpers")
local dpi = beautiful.xresources.apply_dpi

local function create()
  local prev_button = helpers.button({ text = "" })
  local next_button = helpers.button({ text = "" })

  local function decorate_header(widget, flag, _)
    if flag == "header" then
      return wibox.widget({
        layout = wibox.layout.align.horizontal,
        prev_button,
        widget,
        next_button
      })
    end

    if flag == "focus" then
      return wibox.widget({
        widget = wibox.container.background,
        fg = USER.palette.orange,
        {
          widget = wibox.container.margin,
          margins = dpi(2),
          widget
        }
      })
    end

    return wibox.widget({
      widget = wibox.container.background,
      {
        widget = wibox.container.margin,
        margins = dpi(2),
        widget
      }
    })
  end

  local calendar = wibox.widget({
    date = os.date("*t"),
    font = USER.font(12),
    spacing = dpi(1),
    widget = wibox.widget.calendar.month,
    fn_embed = decorate_header,
    forced_height = dpi(220),
    align = "center",
    week_numbers = true,
    long_weekdays = true,
  })

  calendar.change_month = function(self, val)
    local date = self:get_date()
    self:set_date(nil)
    date.month = date.month + val
    self:set_date(date)
  end

  prev_button:buttons(gears.table.join(
    awful.button({}, 1, function()
      calendar:change_month(-1)
    end)
  ))

  next_button:buttons(gears.table.join(
    awful.button({}, 1, function()
      calendar:change_month(1)
    end)
  ))

  return calendar
end

return create()
