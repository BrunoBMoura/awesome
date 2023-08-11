local wibox = require("wibox")
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
  },
  get_sink = {
    cmd = [[bash -c "pactl list sinks | grep -E 'State:|Description:'"]],
    interval = 1
  }
}

local volume = {}

local function worker()
  volume.widget = wibox.widget {
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    font = beautiful.font
  }

  -- Set the initial tooltip value.
  volume.tooltip = ""
  utils.simple_tooltip({ volume.widget }, function()
    return string.format("Sink: %s", volume.tooltip)
  end)

  -- And setup a watch to update the tooltip content.
  watch(PROCS.get_sink.cmd, PROCS.get_sink.interval, function(_, stdout)
    -- Parses the stdout for the get sink command.
    local function extract_running_sink(text_stream)
      local lines = {}
      -- First, parse the stdout into a table of lines.
      for line in text_stream:gmatch("[^\r\n]+") do
        table.insert(lines, line)
      end

      -- Then, iterate on line pairs.
      for idx = 1, #lines, 2 do
        -- Proceed only if both lines in the pair are not nil.
        if lines[idx] and lines[idx + 1] then
          -- Check if the State (idx) line indicates the current device as active.
          if string.match(lines[idx], "RUNNING") then
            -- If so, return the Description (idx + 1) line properly parsed.
            return string.gsub(lines[idx + 1], "Description: ", "")
          end
        end
      end

      return "No device found"
    end

    volume.tooltip = extract_running_sink(stdout)
  end)

  local function update_volume_widget(widget, stdout)
    local _, vol = stdout:match(PROCS.get_volume.match)
    widget:set_text(string.format("Vol:%s%%", vol))
  end
  -- Then setup a watch to update the widget content.
  watch(PROCS.get_volume.cmd, PROCS.get_volume.interval, update_volume_widget, volume.widget)

  -- And finally set the volume widget methods.
  volume.widget.increase = function(percent)
    spawn.easy_async(PROCS.increase.call("pulse", percent))
  end

  volume.widget.decrease = function(percent)
    spawn.easy_async(PROCS.decrease.call("pulse", percent))
  end

  return volume.widget
end

return worker()
