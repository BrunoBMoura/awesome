local helpers = require("config.widgets.helpers")
local awful = require("awful")
local gears = require("gears")

local PROCS = {
  main_menu_opts = {
    { name = "poweroff", command = "poweroff", text = "󰐥" },
    { name = "reboot", command = "reboot", text = "󰜉" },
    { name = "exit", command = "loginctl terminate-session 1", text = "󰍃" }
  }
}

-- menu widget module.
local menu = {}

local function create(opts)
  opts = opts or {}
  local text = opts.text or "Menu"
  local font_size = opts.font_size or 20

  menu.widget = helpers.simple_textbox()
  menu.widget.font = USER.font(font_size)
  menu.widget:set_text(string.format(" %s  ", text))

  local popup_widget = helpers.popup_menu(PROCS.main_menu_opts)

  menu.widget.show_popup = function()
    popup_widget:toggle()
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

return setmetatable(menu, { __call = function(_, ...) return create(...) end })
