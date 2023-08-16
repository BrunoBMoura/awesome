local utils = require("config.widgets.utils")
local awful = require("awful")
local spawn = require("awful.spawn")
local gears = require("gears")

local PROCS = {
  show_popup = function()
    local script_name = "scripts/pulseaudio/rofi_sink_swap.sh"
    local script_path = gears.filesystem.get_configuration_dir()
    return string.format("bash %s/%s", script_path, script_name)
  end
}

-- menu widget module.
local menu = {}

local function worker()
  menu.widget = utils.simple_textbox()
  menu.widget.font = USER.font(20)
  menu.widget:set_text("   ")

  menu.widget.show_popup = function()
    spawn.with_shell(PROCS.show_popup())
  end

  menu.widget:buttons(
    gears.table.join(
      awful.button({ }, 1, function()
        menu.widget:show_popup()
      end)
    )
  )

  return menu.widget
end

return worker()
