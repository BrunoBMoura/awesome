local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local helpers = require("config.widgets.helpers")

-- Local widget information.
local PROC = {
  cmd = [[bash -c "mpstat | grep -oE 'all\s+([0-9]+,[0-9]+)'"]],
  match = helpers.build_match_for(1),
  interval = 5
}

-- cpu widget module.
local cpu = {}

local function worker(opts)
  opts = opts or {}
  local icon = opts.icon or "Cpu:"
  cpu.widget = helpers.simple_textbox()

  spawn.easy_async(PROC.cmd, function(stdout)
    local used = stdout:match(PROC.match)
    cpu.widget:set_text(string.format("%s%s%%", icon, used))
  end)

  local function update_cpu_widget(widget, stdout)
    local used = stdout:match(PROC.match)
    widget:set_text(string.format("%s%s%%", icon, used))
  end

  watch(PROC.cmd, PROC.interval, update_cpu_widget, cpu.widget)

  return cpu.widget
end

-- return worker()
return setmetatable(cpu, { __call = function(_, ...) return worker(...) end })
