local utils = require("config.widgets.utils")
local awful = require("awful")
local spawn = require("awful.spawn")
local gears = require("gears")

local PROCS = {
  show_popup = function()
    local script_name = "scripts/system/rofi_power_menu.sh"
    local script_path = gears.filesystem.get_configuration_dir()
    return string.format("bash %s/%s", script_path, script_name)
  end
}

-- menu widget module.
local menu = {}

local function worker(opts)
  opts = opts or {}
  local icon = opts.icon or "Menu"
  local font_size = opts.font_size or 20

  menu.widget = utils.simple_textbox()
  menu.widget.font = USER.font(font_size)
  menu.widget:set_text(string.format(" %s  ", icon))

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

return setmetatable(menu, { __call = function(_, ...) return worker(...) end })
