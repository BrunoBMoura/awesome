local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local utils = require("config.widgets.utils")
local dpi = require("beautiful").xresources.apply_dpi

-- Local widget information.
local PROC = {
  cmd = [[bash -c "mpstat | grep -oE 'all\s+([0-9]+,[0-9]+)'"]],
  match = utils.build_match_for(1),
  interval = 5
}

-- cpu widget module.
local cpu = {}

local function worker(opts)
  opts = opts or {}
  local icon = opts.icon or "Cpu:"
  local color = opts.color or USER.palette.green

  cpu.widget = utils.arc(color, dpi(12), icon)

  spawn.easy_async(PROC.cmd, function(stdout)
    local used = stdout:match(PROC.match)
    cpu.widget:set_text(string.format("%s%s%%", icon, used))

    local text_widget = cpu.widget:get_children()[1]
    text_widget:set_text(string.format("%s%s%%", icon, used))
    cpu.widget.value = 100 - tonumber(used)
  end)

  local function update_cpu_widget(widget, stdout)
    local used = stdout:match(PROC.match)

    local text_widget = widget:get_children()[1]
    text_widget:set_text(string.format("%s%s%%", icon, used))
    widget.value = 100 - tonumber(used)
  end

  watch(PROC.cmd, PROC.interval, update_cpu_widget, cpu.widget)

  return cpu.widget
end

-- return worker()
return setmetatable(cpu, { __call = function(_, ...) return worker(...) end })
