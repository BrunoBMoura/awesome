local wibox = require("wibox")
local beautiful = require("beautiful")

local clock = {}

local function create(opts)
  opts = opts or {}
  local color = opts.color or beautiful.fg_normal
  local text = opts.text or ""

  clock.widget = wibox.widget.textclock(
    '<span color="' .. color .. '"> ' .. text .. '%H:%M</span>'
  )

  clock.widget.font = USER.font(45)
  clock.widget.align = "center"

  return clock.widget
end

-- Set the __call method to allow clock() to be called with its necessary arguments.
return setmetatable(clock, { __call = function(_, ...) return create(...) end })
