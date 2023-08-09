local wibox = require("wibox")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local utils = require("config.widgets.utils")

-- Local widget information.
local PROC = {
  cmd = "free | grep Mem",
  match = "(%d+)%s+(%d+)%s+(%d+)",
  interval = 5
}

-- Returns a table containing the total, used and free ram
-- memory of the system.
local function get_ram_usage()
  local result = utils.invoke(PROC.cmd)
  local total, used, free = result:match(PROC.match)
  return {
    total = tonumber(total),
    used = tonumber(used),
    free = tonumber(free)
  }
end

-- Ram widget module.
local ram = {}

ram.create = function()
  local ram_widget = wibox.widget {
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    font = beautiful.font
  }

  local function update_ram_widget()
    local ram_info = get_ram_usage()
    local ram_percentage = math.floor((ram_info.used / ram_info.total) * 100)
    ram_widget:set_text(string.format("RAM:%s%%", ram_percentage))
  end

  update_ram_widget()

  watch(PROC.cmd, PROC.interval, update_ram_widget, ram_widget)

  return ram_widget
end

return ram
