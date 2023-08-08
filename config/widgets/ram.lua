local wibox = require("wibox")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")

local ram = {}

ram.create = function()
  local ram_widget = wibox.widget {
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    font = beautiful.font
  }

  local function get_ram_usage()
    local handle = io.popen("free | grep Mem")
    local result = handle:read("*a")
    handle:close()

    local total, used, free = result:match("(%d+)%s+(%d+)%s+(%d+)")
    return {
      total = tonumber(total),
      used = tonumber(used),
      free = tonumber(free)
    }
  end

  local function update_ram_widget()
    local ram_info = get_ram_usage()
    local ram_percentage = math.floor((ram_info.used / ram_info.total) * 100)
    ram_widget:set_text("RAM:" .. ram_percentage .. "%")
  end

  update_ram_widget()

  watch("free | grep Mem", 5, update_ram_widget, ram_widget)

  return ram_widget
end

return ram
