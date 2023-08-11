local wibox = require("wibox")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local utils = require("config.widgets.utils")
local spawn = require("awful.spawn")

-- Local widget information.
local PROC = {
  cmd = "free | grep Mem",
  match = "(%d+)%s+(%d+)%s+(%d+)",
  interval = 5
}

-- Ram widget module.
local ram = {}

local function worker(user_args)

  ram.widget = wibox.widget({
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    font = beautiful.font
  })

  spawn.easy_async_with_shell(PROC.cmd, function(stdout)
    local total, used, free = stdout:match(PROC.match)
    local ram_percentage = math.floor((used / total) * 100)
    ram.widget:set_text(string.format("Ram:%s%%", ram_percentage))
  end)

  local function update_ram_widget(widget, stdout)
    local total, used, free = stdout:match(PROC.match)
    -- local ram_info = get_ram_usage()
    local ram_percentage = math.floor((used / total) * 100)
    widget:set_text(string.format("Ram:%s%%", ram_percentage))
  end

  -- update_ram_widget()

  watch(PROC.cmd, 1, update_ram_widget, ram.widget)

  return ram.widget
end

return setmetatable(ram, { __call = function(_, ...) return worker(...) end })