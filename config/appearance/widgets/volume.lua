local watch = require("awful.widget.watch")
local helpers = require("config.appearance.helpers")
local awful = require("awful")
local gears = require("gears")

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
    match = helpers.build_match_for(10),
    interval = 1
  },
  get_sink = {
    cmd = [[bash -c "pactl list sinks | grep -E 'State:|Description:'"]],
    interval = 1
  },
  popup_swap_sink = function()
    local script_name = "scripts/pulseaudio/rofi_sink_swap.sh"
    local script_path = gears.filesystem.get_configuration_dir()
    return string.format("bash %s/%s", script_path, script_name)
  end,
  --[[ popup_swap_source = function()
    local script_name = "scripts/pulseaudio/rofi_source_swap.sh"
    local script_path = gears.filesystem.get_configuration_dir()
    return string.format("bash %s/%s", script_path, script_name)
  end, ]]
}

local volume = {}

local function worker(opts)
  opts = opts or {}
  volume.widget = helpers.simple_textbox()

  -- Set the initial tooltip value.
  volume.tooltip = {}
  volume.tooltip.source = ""
  helpers.simple_tooltip({ volume.widget }, function()
    return string.format("Sink: %s", volume.tooltip.source)
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

      return "No sources in use"
    end

    volume.tooltip.source = extract_running_sink(stdout)
  end)

  local icon = opts.icon or "Vol:"
  local function update_volume_widget(widget, stdout)
    local _, vol = stdout:match(PROCS.get_volume.match)
    -- If the volume is nil, set it to 0.
    widget:set_text(string.format(" %s%s%% ", icon, tonumber(vol or "0")))
  end
  -- Then setup a watch to update the widget content.
  watch(PROCS.get_volume.cmd, PROCS.get_volume.interval, update_volume_widget, volume.widget)

  -- And finally set the volume widget methods.
  volume.widget.increase = function(_, percent)
    helpers.simple_spawn(PROCS.increase.call("pulse", percent))
  end

  volume.widget.decrease = function(_, percent)
    helpers.simple_spawn(PROCS.decrease.call("pulse", percent))
  end

  volume.widget.popup_swap_sink = function()
    helpers.simple_spawn(PROCS.popup_swap_sink())
  end

  volume.widget:buttons(
    gears.table.join(
      awful.button({ }, 1, function()
        volume.widget:popup_swap_sink()
      end),
      awful.button({ }, 3, function()
        volume.widget:popup_swap_sink()
      end)
    )
  )

  return volume.widget
end

return setmetatable(volume, { __call = function(_, ...) return worker(...) end })
