local helpers = require("config.widgets.helpers")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")

-- Local widget information.
local PROCS = {
  cmd = [[bash -c "nc -z 8.8.8.8 53"]],
  interval = 5
}

-- Ram widget module.
local net = {}

local function worker(opts)
  opts = opts or {}
  local icon = opts.icon or "Net:"

  net.widget = helpers.simple_textbox()

  local function update_net_widget(widget, _, --[[stdout]]_, --[[exit_signal]]_, exit_code)
    local text = exit_code == 0 and "Up " or "Down "
    widget:set_text(string.format("%s%s", icon, text))
  end

  spawn.easy_async(PROCS.cmd, function(stdout, exit_signal, exit_code)
    update_net_widget(net.widget, nil, stdout, exit_signal, exit_code)
  end)

  watch(PROCS.cmd, PROCS.interval, update_net_widget, net.widget)

  return net.widget
end

return setmetatable(net, { __call = function(_, ...) return worker(...) end })
