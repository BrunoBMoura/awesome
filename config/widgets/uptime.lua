local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local utils = require("config.widgets.utils")

-- Local widget information.
local PROCS = {
  main = {
    cmd = [[bash -c "uptime -p | grep -Eo '[0-9]{1,2}'"]],
    match = "(%d+)%s+(%d+)",
    submatch = "(%d+)",
    interval = 30
  },
  tooltip = {
    cmd = [[ bash -c "uptime -s | grep -Eo '[0-9]{1,6}'"]],
    match = "(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)"
  }
}

-- Ram widget module.
local uptime = {}

local function worker()
  uptime.widget = utils.simple_textbox()

  local startup = {}
  spawn.easy_async(PROCS.tooltip.cmd, function(stdout)
    startup.year, startup.month, startup.day,
    startup.hour, startup.min, startup.sec = stdout:match(PROCS.tooltip.match)
  end)

  utils.simple_tooltip({ uptime.widget }, function()
    return string.format(
      "Up since %s/%s/%s, %s:%s:%s",
      startup.day, startup.month, startup.year,
      startup.hour, startup.min, startup.sec
    )
  end)

  local function update_uptime_widget(widget, stdout)
    -- Simple prettyfier function to add trailing zeros to the time value.
    local function prettyfy_time(time)
      return tonumber(time) < 10 and "0" .. time or time
    end
    -- If the uptime is less than 1 hour, hours will be nil,
    -- which means that the first match will fail due to it expecting
    -- two numbers to be matched. In this case we then reperform the
    -- match but this time only matching the minutes.
    local function time_parser(time_string)
      local hour, min = time_string:match(PROCS.main.match)
      if hour == nil and min == nil then
        min = time_string:match(PROCS.main.submatch)
        return { hour = prettyfy_time(0), min = prettyfy_time(min) }
      end
      return { hour = prettyfy_time(hour), min = prettyfy_time(min) }
    end

    -- Properly access uptime information and set it as the widgets text.
    local uptime_info = time_parser(stdout)
    widget:set_text(string.format("Uptime:%sh%sm", uptime_info.hour, uptime_info.min))
  end

  watch(PROCS.main.cmd, PROCS.main.interval, update_uptime_widget, uptime.widget)

  return uptime.widget
end

return worker()
