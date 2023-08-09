local wibox = require("wibox")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local utils = require("config.widgets.utils")

-- Local widget information.
local PROCS = {
  main = {
    cmd = "uptime -p | grep -Eo '[0-9]{1,2}'",
    match = "(%d+)%s+(%d+)",
    submatch = "(%d+)",
    interval = 30
  },
  tooltip = {
    cmd = "uptime -s | grep -Eo '[0-9]{1,6}'",
    match = "(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)"
  }
}

-- Returns a table containing the startup time of the system,
-- called only once upong startup.
local function get_startup_time()
  local result = utils.invoke(PROCS.tooltip.cmd)
  local year, month, day, hour, min, sec = result:match(PROCS.tooltip.match)
  return {
    year = year,
    month = month,
    day = day,
    hour = hour,
    min = min,
    sec = sec
  }
end

-- Returns a table containing the uptime of the system,
-- called at every interval.
local function get_uptime()
  local result = utils.invoke(PROCS.main.cmd)
  -- If the uptime is less than 1 hour, hours will be nil,
  -- which means that the first match will fail due to it expecting
  -- two numbers to be matched. In this case we then reperform the
  -- match but this time only matching the minutes.
  local hour, min = result:match(PROCS.main.match)
  if hour == nil and min == nil then
    min = result:match(PROCS.main.submatch)
    return {
      hour = "00",
      min = min
    }
  end
  return {
    hour = hour,
    min = min
  }
end

-- Ram widget module.
local uptime = {}

uptime.create = function()
  local uptime_widget = wibox.widget {
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    font = beautiful.font
  }

  utils.simple_tooltip({ uptime_widget }, function()
    local startup = get_startup_time()
    return string.format(
      "Up since %s/%s/%s, %s:%s:%s",
      startup.day, startup.month, startup.year,
      startup.hour, startup.min, startup.sec
    )
  end)

  --[[ awful.tooltip({
    objects = { uptime_widget },
    mode = "outside",
    align = "right",
    timer_function = function()
      local startup = get_startup_time()
      return string.format(
        "Up since %s/%s/%s, %s:%s:%s",
        startup.day, startup.month, startup.year,
        startup.hour, startup.min, startup.sec
      )
    end,
    preferred_positions = { "bottom", "center" },
    margin_leftright = dpi(15),
    margin_topbottom = dpi(15)
  }) ]]

  local function update_uptime_widget()
    local uptime_info = get_uptime()
    uptime_widget:set_text(
      string.format("Uptime: %sh%sm", uptime_info.hour, uptime_info.min)
    )
  end

  update_uptime_widget()

  watch(PROCS.main.cmd, PROCS.main.interval, update_uptime_widget, uptime_widget)

  return uptime_widget
end

return uptime
