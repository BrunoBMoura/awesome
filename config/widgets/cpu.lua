local wibox = require("wibox")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")

-- Local widget information.
local PROC = {
  cmd = [[bash -c "mpstat | grep -oE 'all\s+([0-9]+,[0-9]+)'"]],
  match = "(%d+)",
  interval = 5
}

-- cpu widget module.
local cpu = {}

local function worker()
  cpu.widget = wibox.widget({
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    font = beautiful.font
  })

  spawn.easy_async(PROC.cmd, function(stdout)
    local used = stdout:match(PROC.match)
    cpu.widget:set_text(string.format("Cpu:%s%%", used))
  end)

  local function update_cpu_widget(widget, stdout)
    local used = stdout:match(PROC.match)
    widget:set_text(string.format("Cpu:%s%%", used))
  end

  watch(PROC.cmd, PROC.interval, update_cpu_widget, cpu.widget)

  return cpu.widget
end

return worker()
