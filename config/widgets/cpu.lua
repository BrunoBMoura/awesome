local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local utils = require("config.widgets.utils")

-- Local widget information.
local PROC = {
  cmd = [[bash -c "mpstat | grep -oE 'all\s+([0-9]+,[0-9]+)'"]],
  match = utils.build_match_for(1),
  interval = 5
}

-- cpu widget module.
local cpu = {}

local function worker()
  cpu.widget = utils.simple_textbox()

  spawn.easy_async(PROC.cmd, function(stdout)
    local used = stdout:match(PROC.match)
    cpu.widget:set_text(string.format(" %s%%", used))
  end)

  local function update_cpu_widget(widget, stdout)
    local used = stdout:match(PROC.match)
    widget:set_text(string.format(" %s%%", used))
  end

  watch(PROC.cmd, PROC.interval, update_cpu_widget, cpu.widget)

  return cpu.widget
end

return worker()
