local watch = require("awful.widget.watch")
local helpers = require("config.helpers")
local naughty = require("naughty")

-- Local widget information.
local PROC = {
  cmd = [[bash -c "acpi | grep -m1 'Battery'"]],
  interval = 15,
  state_strings = {
    full        = "Full",
    charging    = "Charging",
    discharging = "Discharging",
  }
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
    batt.text = string.format(
      "%s, %02d:%02d:%02d remaining",
      state, hour, min, sec
    )

    -- If the first iteration, just save the result.
    percentage = tonumber(percentage)
    if batt.current_percentage == nil then
      batt.current_percentage = percentage
      return
    end

    local function eval_border_color(state, percentage)
      if state == "Charging" then
        return USER.palette.green
      else
        return percentage <= 10 and USER.palette.red or USER.palette.yellow
      end
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
        border_color = eval_border_color(state, percentage)
      })
      batt.current_percentage = percentage
    end
  end

  local function update_batt_widget(widget, stdout)
    if stdout:match(PROC.state_strings.full) then
      widget:set_text(string.format(" %s%s ", icon, PROC.state_strings.full))
      batt.text = "Battery is full"
      batt.current_percentage = 100
      return
    end

    -- Check the battery state.
    local state = stdout:match(PROC.state_strings.charging) and
      PROC.state_strings.charging or PROC.state_strings.discharging

    -- Then, get the battery percentage and time remaining.
    local values = helpers.extract_numbers(stdout)
    local --[[id]]_, percentage, hour, min, sec = values[1], values[2], values[3], values[4], values[5]
    -- Notify if necessary.
    eval_batt_non_full(state, percentage, hour, min, sec)
    -- And update the widget.
    widget:set_text(string.format(" %s%s%% ", icon, percentage))
  end

  watch(PROC.cmd, PROC.interval, update_batt_widget, batt.widget)

  return batt.widget
end

return setmetatable(batt, { __call = function(_, ...) return worker(...) end })
