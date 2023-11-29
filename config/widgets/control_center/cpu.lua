local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local helpers = require("config.widgets.helpers")
local dpi = require("beautiful").xresources.apply_dpi

-- Local widget information.
local PROC = {
  cmd = [[bash -c "mpstat | grep -oE 'all\s+([0-9]+.[0-9]+)'"]],
  match = helpers.build_match_for(1),
  interval = 5
}

-- cpu widget module.
local cpu = {}

local function worker(opts)
  opts = opts or {}
  local text = opts.text or "Cpu:"
  local color = opts.color or USER.palette.green

  cpu.widget = helpers.arc(color, dpi(12), text)

  local function update_cpu_widget(widget, stdout)
    local used = stdout:match(PROC.match)
    local text_widget = widget:get_children()[1]
    text_widget:set_text(string.format("%s%s%%", text, used))
    widget.value = 100 - tonumber(used)
  end

  spawn.easy_async(PROC.cmd, function(stdout)
    update_cpu_widget(cpu.widget, stdout)
  end)

  watch(PROC.cmd, PROC.interval, update_cpu_widget, cpu.widget)

  return cpu.widget
end

return setmetatable(cpu, { __call = function(_, ...) return worker(...) end })
