local spawn = require("awful.spawn")
local helpers = require("config.helpers")
local watch = require("awful.widget.watch")
local colors = require("beautiful").palette

local PROCS = {
  set_brightness = function(value)
    return string.format("xbacklight -set %s", value)
  end,
  get_brightness = [[bash -c "xbacklight -get"]],
  match = helpers.build_match_for(1),
  interval = 1
}

local brightness = {}

local function worker(opts)
  opts = opts or {}

  opts.text = opts.text or "Brt: "
  opts.font = opts.font or USER.font(10)
  opts.color = opts.color or colors.yellow
  opts.value = opts.value or 20

  brightness.widget = helpers.slider_widget(opts.text, opts.color, opts.font)

  local function init_brightness(initial_value)
    -- Set the initial brightness value.
    spawn.with_shell(PROCS.set_brightness(initial_value))
    brightness.widget:set_value(initial_value)

    -- Connect the callback function to be invoked whenever the brightness slider
    -- is updated.
    brightness.widget:connect_function_upon_redraw(function(slider_value)
      spawn.with_shell(PROCS.set_brightness(slider_value))
    end)

    -- Finally, setup a watch to update the volume slider if the brightness is update
    -- by another source.
    local function update_brightness_slider(widget, stdout)
      local value = stdout:match(PROCS.match)
      -- If the brightness is nil, set it to 0.
      widget:set_value(tonumber(value or "10"))
    end

    watch(PROCS.get_brightness, PROCS.interval, update_brightness_slider, brightness.widget)
  end

  init_brightness(opts.value)

  return brightness.widget
end

return setmetatable(brightness, { __call = function(_, ...) return worker(...) end })
