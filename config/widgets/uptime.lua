local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local dpi = beautiful.xresources.apply_dpi

local uptime = {}

uptime.create = function()
  local uptime_widget = wibox.widget {
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    font = beautiful.font
  }

  -- Access the initial startup time since it only needs to be calculated once.
  local function get_startup_time()
    local handle = io.popen("uptime -s | grep -Eo '[0-9]{1,6}'")
    local result = handle:read("*a")
    handle:close()

    local year, month, day, hour, min, sec = result:match(
      "(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)"
    )
    return day .. "/" .. month .. "/" .. year .. ", " ..
           hour .. ":" .. min .. ":" .. sec
  end

  local startup_time = get_startup_time()

  awful.tooltip({
    objects = { uptime_widget },
    mode = "outside",
    align = "right",
    timer_function = function()
       return "Up since " .. startup_time
    end,
    preferred_positions = { "bottom", "center" },
    margin_leftright = dpi(15),
    margin_topbottom = dpi(15)
  })

  local function get_uptime()
    local handle = io.popen("uptime -p | grep -Eo '[0-9]{1,2}'")
    local result = handle:read("*a")
    handle:close()

    local hours, min = result:match("(%d+)%s+(%d+)")
    return {
      hour = tonumber(hours),
      min = tonumber(min)
    }
  end

  local function update_uptime_widget()
    local ram_info = get_uptime()
    uptime_widget:set_text("UPTIME:" .. ram_info.hour .. "h" .. ram_info.min .. "m")
  end

  update_uptime_widget()

  watch("uptime -p | grep -Eo '[0-9]{1,2}'", 30, update_uptime_widget, uptime_widget)

  return uptime_widget
end

return uptime
