local helpers = require("config.widgets.helpers")
local awful = require("awful")
local spawn = require("awful.spawn")
local gears = require("gears")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

local PROCS = {
  show_popup = function()
    local script_name = "scripts/system/rofi_power_menu.sh"
    local script_path = gears.filesystem.get_configuration_dir()
    return string.format("bash %s/%s", script_path, script_name)
  end,
  elements = {
    { name = "poweroff", command = "poweroff", icon = "󰐥" },
    { name = "reboot", command = "reboot", icon = "󰜉" },
    { name = "exit", command = "loginctl terminate-session 1", icon = "󰍃" }
  },
}

local options_container = wibox.widget({
  homogeneous = false,
  expand = true,
  forced_num_cols = 3,
  spacing = dpi(10),
  layout = wibox.layout.grid
})

local prompt = wibox.widget({
  widget = wibox.widget.textbox,
  visible = false
})

local main_widget = wibox.widget({
  widget = wibox.container.margin,
  margins = dpi(10),
  {
    layout = wibox.layout.fixed.vertical,
    prompt,
    options_container
  }
})

local popup_widget = awful.popup {
  visible = false,
  ontop = true,
  bg = beautiful.background,
  border_color = beautiful.border_color,
  border_width = beautiful.border_width,
  placement = function(d)
    awful.placement.centered(d)
  end,
  widget = main_widget
}

--[[
10 -> 4 % 10 + 1 = 5
10 -> 4 % 10 - 1 = 3
--]]
for _, element in ipairs(PROCS.elements) do
  local element_widget = wibox.widget({
    widget = wibox.container.background,
    forced_width = dpi(100),
    forced_height = dpi(100),
    buttons = {
      awful.button({}, 1, function ()

      end)
    },
    {
      widget = wibox.widget.textbox(),
      fg = beautiful.fg_normal,
      align = "center",
      font = USER.font(40),
      markup = element.icon
    }
  })
  options_container:add(element_widget)
end


-- menu widget module.
local menu = {}

local function worker(opts)
  opts = opts or {}
  local icon = opts.icon or "Menu"
  local font_size = opts.font_size or 20

  menu.widget = helpers.simple_textbox()
  menu.widget.font = USER.font(font_size)
  menu.widget:set_text(string.format(" %s  ", icon))

  menu.widget.show_popup = function()
    -- spawn.with_shell(PROCS.show_popup())
    if popup_widget.visible then
      popup_widget.visible = false
      return
    end
    popup_widget.visible = true
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
