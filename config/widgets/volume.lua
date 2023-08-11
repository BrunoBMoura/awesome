local wibox = require("wibox")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local utils = require("config.widgets.utils")
local spawn = require("awful.spawn")

local PROCS = {
  increase = function(device, step)
    return string.format("amixer -D %s sset Master %s%%+", device, step)
  end,
  decrease = function(device, step)
    return string.format("amixer -D %s sset Master %s%%-", device, step)
  end,
  get_volume = function(device)
    return string.format("amixer -D %s sget Master", device)
  end
}

local volume = {}

volume.create = function()
  local volume_widget = wibox.widget {
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    font = beautiful.font
  }

  utils.simple_tooltip({ volume_widget }, function ()
    return PROCS.increase("pulse", 5)
  end)

  volume_widget.increase = function(percent)
    --[[ local volume = volume or 5
    utils.invoke("amixer -D pulse sset Master 5%+") ]]
    -- utils.invoke("pactl set-sink-volume @DEFAULT_SINK@ +5%")
    -- utils.invoke("notify-send 'Volume' 'Volume increased'")
    volume_widget:set_text("Last increase " .. percent)
  end

  volume_widget.decrease = function(percent)
    --[[ local volume = volume or 5
    utils.invoke("amixer -D pulse sset Master 5%-") ]]
    -- utils.invoke("pactl set-sink-volume @DEFAULT_SINK@ -5%")
    -- utils.invoke("notify-send 'Volume' 'Volume decreased'")
    volume_widget:set_text("Last decrease " .. percent)
  end

  return volume_widget
end

return volume
