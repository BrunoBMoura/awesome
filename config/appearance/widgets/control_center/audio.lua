local helpers = require("config.helpers")
local watch = require("awful.widget.watch")
local colors = require("beautiful").palette

local PROCS = {
  speaker = {
    set_volume = function(device, value)
      return string.format("amixer -D %s sset Master %s%%", device, value)
    end,
    get_volume = {
      cmd = [[bash -c "pactl get-sink-volume @DEFAULT_SINK@ | grep -Eo [0-9]'{,}'"]],
      match = helpers.build_match_for(10),
      interval = 1
    },
  },
  mic = {
    -- set_volume = function(device, value) end,
    -- get_volume = {
      -- cmd = [[bash -c "pactl get-source-volume @DEFAULT_SOURCE@ | grep -Eo [0-9]'{,}'"]],
      -- match = helpers.build_match_for(10),
      -- interval = 1
    -- }
  }
}

local audio = {}

local function worker(opts)
  opts = opts or {}
  opts.mic = opts.mic or {}
  opts.speaker = opts.speaker or {}

  opts.speaker.text = opts.speaker.text or "Speaker:"
  opts.speaker.color = opts.speaker.color or colors.green
  opts.speaker.value = opts.speaker.value or 25

  opts.mic.text = opts.mic.text or "Mic:"
  opts.mic.color = opts.mic.color or colors.orange
  opts.mic.value = opts.speaker.value or 45

  audio.speaker = helpers.slider_widget(opts.speaker.text, opts.speaker.color)
  audio.mic = helpers.slider_widget(opts.mic.text, opts.mic.color)

  -- Simply due to organization, define a function to properly initialize each
  -- of the widgets.

  local function init_speaker(initial_volume)
    -- Set the initial sink volume.
    helpers.simple_spawn(PROCS.speaker.set_volume("pulse", initial_volume))
    audio.speaker:set_value(initial_volume)

    -- Connect the callback function to be invoked whenever the volume slider
    -- is updated.
    audio.speaker:connect_function_upon_redraw(function(slider_value)
      helpers.simple_spawn(PROCS.speaker.set_volume("pulse", slider_value))
    end)

    -- Finally, setup a watch to update the volume slider if the volume is update
    -- by another source.
    local function update_volume_slider(widget, stdout)
      local _, vol = stdout:match(PROCS.speaker.get_volume.match)
      -- If the volume is nil, set it to 0.
      widget:set_value(tonumber(vol or "0"))
    end

    watch(PROCS.speaker.get_volume.cmd, PROCS.speaker.get_volume.interval, update_volume_slider, audio.speaker)
  end

  local function init_mic(initial_volume)
    audio.mic:set_value(initial_volume)
  end

  init_speaker(opts.speaker.value)
  init_mic(opts.mic.value)

  return { speaker = audio.speaker, mic = audio.mic }
end

return setmetatable(audio, { __call = function(_, ...) return worker(...) end })
