local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local helpers = require("config.widgets.helpers")
local dpi = require("beautiful").xresources.apply_dpi

-- Local widget information.
local PROC = {
  cmd = [[bash -c "free | grep Mem"]],
  match = helpers.build_match_for(3),
  interval = 5
}

-- Ram widget module.
local ram = {}

local function worker(opts)
  opts = opts or {}
  local icon = opts.icon or "Ram:"
  local color = opts.color or USER.palette.blue

  ram.widget = helpers.arc(color, dpi(12), icon)

  spawn.easy_async(PROC.cmd, function(stdout)
    local total, used, _ = stdout:match(PROC.match)
    local ram_percentage = math.floor((used / total) * 100)

    local text_widget = ram.widget:get_children()[1]
    text_widget:set_text(string.format("%s%s%%", icon, ram_percentage))
    ram.widget.value = 100 - ram_percentage
  end)

  local function update_ram_widget(widget, stdout)
    local total, used, _ = stdout:match(PROC.match)
    local ram_percentage = math.floor((used / total) * 100)

    local text_widget = widget:get_children()[1]
    text_widget:set_text(string.format("%s%s%%", icon, ram_percentage))
    widget.value = 100 - ram_percentage
  end

  watch(PROC.cmd, PROC.interval, update_ram_widget, ram.widget)

  return ram.widget
end

return setmetatable(ram, { __call = function(_, ...) return worker(...) end })
