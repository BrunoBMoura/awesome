local watch = require("awful.widget.watch")
local helpers = require("config.appearance.helpers")
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
  local text = opts.text or "Ram:"
  local color = opts.color or USER.palette.blue

  ram.widget = helpers.arc(color, dpi(12), text)

  local function update_ram_widget(widget, stdout)
    local total, used, _ = stdout:match(PROC.match)
    local ram_percentage = math.floor((used / total) * 100)

    local text_widget = widget:get_children()[1]
    text_widget:set_text(string.format("%s%s%%", text, ram_percentage))
    widget.value = 100 - ram_percentage
  end

  --[[ helpers.spawn_and_capture(PROC.cmd, function(stdout)
    update_ram_widget(ram.widget, stdout)
  end) ]]

  watch(PROC.cmd, PROC.interval, update_ram_widget, ram.widget)

  return ram.widget
end

return setmetatable(ram, { __call = function(_, ...) return worker(...) end })
