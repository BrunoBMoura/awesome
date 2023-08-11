local wibox = require("wibox")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local utils = require("config.widgets.utils")
local spawn = require("awful.spawn")

local PROCS = {
  increase = {
    call = function(device, step)
      return string.format("amixer -D %s sset Master %s%%+", device, step)
    end
  },
  decrease = {
    call = function(device, step)
      return string.format("amixer -D %s sset Master %s%%-", device, step)
    end
  },
  get_volume =  {
    cmd = [[bash -c "pactl get-sink-volume @DEFAULT_SINK@ | grep -Eo [0-9]'{,}'"]],
    match = "(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)",
    interval = 1
  }
}

local volume = {}

local function worker(_)
  volume.widget = wibox.widget {
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    font = beautiful.font
  }

  utils.simple_tooltip({ volume.widget }, function ()
    return "jorge"
  end)

  volume.widget.increase = function(percent)
    spawn.easy_async_with_shell(PROCS.increase.call("pulse", percent))
  end

  volume.widget.decrease = function(percent)
    spawn.easy_async_with_shell(PROCS.decrease.call("pulse", percent))
  end

  local function update_volume_widget(widget, stdout)
    local _, vol = stdout:match(PROCS.get_volume.match)
    widget:set_text(string.format("Vol:%s%%", vol))
  end

  watch(PROCS.get_volume.cmd, PROCS.get_volume.interval, update_volume_widget, volume.widget)

  return volume.widget
end

return worker()
