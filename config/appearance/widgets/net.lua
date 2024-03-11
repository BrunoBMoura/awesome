local helpers = require("config.appearance.helpers")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")

-- Local widget information.
local PROCS = {
  gather_data_from = function(interface)
    return string.format([[bash -c "ifconfig %s"]], interface)
  end,
  cmd = function(interface)
    return string.format([[bash -c "ifconfig %s | grep %s"]], interface, interface)
  end,
  interval = 5
}

-- Net widget module.
local net = {}

local function worker(opts)
  opts = opts or {}
  local icon = opts.icon or "Net:"
  local interface = opts.interface or "enp5s0"

  net.widget = helpers.simple_textbox()

  -- First, access the network information and set it as the tooltips text.
  spawn.easy_async(PROCS.gather_data_from(interface), function(stdout)
    for line in stdout:gmatch("[^\r\n]+") do
      if line:match("inet ") then
        net.ip = line:match("inet (%d+.%d+.%d+.%d+)")
      elseif line:match("ether") then
        net.mac = line:match("ether (%x+:%x+:%x+:%x+:%x+:%x+)")
      end
    end
  end)

  -- Define the widgets toooltip.
  helpers.simple_tooltip({ net.widget }, function()
    if net.ip == nil or net.mac == nil then return "No wired connection." end
    return string.format("<b>%s: </b>\nIP:  %s\nMAC: %s", interface, net.ip, net.mac)
  end)

  local function update_net_widget(widget, stdout)
    local text = stdout:match("RUNNING") and "Up" or "Down"
    widget:set_text(string.format("%s%s ", icon, text))
  end

  -- And perform the first update on the widgets text.
  spawn.easy_async(PROCS.cmd, function(stdout)
    update_net_widget(net.widget, stdout)
  end)

  watch(PROCS.cmd(interface), PROCS.interval, update_net_widget, net.widget)

  return net.widget
end

return setmetatable(net, { __call = function(_, ...) return worker(...) end })
