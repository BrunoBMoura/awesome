local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local helpers = require("config.appearance.helpers")
local naughty = require("naughty")

-- Local widget information.
local PROC = {
  cmd = [[bash -c "acpi"]],
  match = "Battery (%d+): (%a+), (%d+)%%, (%d+):(%d+):(%d+)",
  interval = 15
}

-- batt widget module.
local batt = {
  current_percentage = nil,
  text = "Checking battery status...",
}

local function worker(opts)
  opts = opts or {}
  local icon = opts.icon or "Batt:"

  batt.widget = helpers.simple_textbox()

  helpers.simple_tooltip({ batt.widget }, function()
    return batt.text
  end)

  local function eval_batt_non_full(state, percentage, hour, min, sec)
    -- Set the value of the tooltip text.
    batt.text = string.format("%s, %s:%s:%s remaining", state, hour, min, sec)
    -- If the first iteration, just save the result.
    percentage = tonumber(percentage)
    if batt.current_percentage == nil then
      batt.current_percentage = percentage
      return
    end

    -- If the percentage is different, notify the user at steps of 10%.
    local current_decimal = math.floor(batt.current_percentage / 10)
    local new_decimal = math.floor(percentage / 10)
    if current_decimal ~= new_decimal then
      naughty.notify({
        title = "Battery status",
        text = string.format(
          "Battery is at %s%%, %s:%s:%s remaining.", percentage, hour, min, sec
        ),
        border_color = percentage <= 10 and USER.palette.red or USER.palette.green,
      })
      batt.current_percentage = percentage
    end
  end

  local function update_batt_widget(widget, stdout)
    if stdout:match("Full") then
      widget:set_text(string.format(" %s%s ", icon, "Full"))
      batt.text = "Battery is full"
      batt.current_percentage = 100
    else
      local --[[id]]_, state, percentage, hour, min, sec = stdout:match(PROC.match)
      widget:set_text(string.format(" %s%s%% ", icon, percentage))
      eval_batt_non_full(state, percentage, hour, min, sec)
    end

  end

  spawn.easy_async(PROC.cmd, function(stdout)
    update_batt_widget(batt.widget, stdout)
  end)

  watch(PROC.cmd, PROC.interval, update_batt_widget, batt.widget)

  return batt.widget
end

return setmetatable(batt, { __call = function(_, ...) return worker(...) end })
