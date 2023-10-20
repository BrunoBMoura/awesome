local wibox = require("wibox")
local beautiful = require("beautiful")

-- time widget module.
local date = {}

local function create(opts)
  opts = opts or {}
  local color = opts.color or beautiful.fg_normal
  local icon = opts.icon or "Date:"

  date.widget = wibox.widget.textclock(
    '<span color="'.. color .. '">' .. icon .. ' %d/%m, %H:%M </span>'
  )

  return date.widget
end

-- Set the __call method to allow time() to be called with its necessary arguments.
return setmetatable(date, { __call = function(_, ...) return create(...) end })
