local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local colors = beautiful.palette
local helpers = require("config.widgets.helpers")

local audio = {}

local function create(opts)
  opts = opts or {}
  opts.mic = opts.mic or false
  opts.speaker = opts.speaker or false

  opts.speaker.icon = opts.speaker.icon or "  "
  opts.speaker.color = opts.speaker.color or colors.green

  opts.mic.icon = opts.mic.icon or "  "
  opts.mic.color = opts.mic.color or colors.orange

  audio.speaker = helpers.slider_widget(opts.speaker.icon, opts.speaker.color)
  audio.mic = helpers.slider_widget(opts.mic.icon, opts.mic.color)

  audio.speaker:set_value(34)
  audio.mic:set_value(43)

  return { speaker = audio.speaker, mic = audio.mic }
end

return setmetatable(audio, { __call = function(_, ...) return create(...) end })
