local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local helpers = require("config.widgets.helpers")
local dpi = require("beautiful").xresources.apply_dpi

-- Local widget information.
local PROC = {
  cmd = [[bash -c "df -h | grep %s"]],
  match = "(%d+%%)",
  interval = 30
}

local function build_cmd(device)
  return string.format(PROC.cmd, device)
end

-- disk widget module.
local disk = {}

local function worker(opts)
  opts = opts or {}
  local text = opts.text or "Disk:"
  local device = opts.device or "/dev/sda1"
  local color = opts.color or USER.palette.red

  disk.widget = helpers.arc(color, dpi(12), text)

  spawn.easy_async(build_cmd(device), function(stdout)
    local used_disk_percentage  = stdout:match(PROC.match)
    used_disk_percentage = used_disk_percentage:gsub("%%", "")
    used_disk_percentage = tonumber(used_disk_percentage)

    local text_widget = disk.widget:get_children()[1]
    text_widget:set_text(string.format("%s%s%%", text, used_disk_percentage))
    disk.widget.value = 100 - used_disk_percentage
  end)

  local function update_disk_widget(widget, stdout)
    local used_disk_percentage  = stdout:match(PROC.match)
    used_disk_percentage = used_disk_percentage:gsub("%%", "")
    used_disk_percentage = tonumber(used_disk_percentage)

    local text_widget = widget:get_children()[1]
    text_widget:set_text(string.format("%s%s%%", text, used_disk_percentage))
    widget.value = 100 - used_disk_percentage
  end

  watch(build_cmd(device), PROC.interval, update_disk_widget, disk.widget)

  return disk.widget
end

return setmetatable(disk, { __call = function(_, ...) return worker(...) end })
