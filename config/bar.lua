local utils = require("config.widgets.utils")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

local colors = USER.palette
local custom_wibox = {}

local function create(screen)
  local separator = wibox.widget.textbox(" ")
  local menu = require("config.widgets.menu")({ icon = " " })
  local calendar = require("config.widgets.calendar")(screen, {
    icon = "󰃰", color = colors.cyan
  })
  local cpu = require("config.widgets.cpu")({ icon = " " })
  local ram = require("config.widgets.ram")({ icon = " " })
  local uptime = require("config.widgets.uptime")({ icon = "󰚰 "})

  return {
    spacing = dpi(50),
    layout = wibox.layout.align.horizontal,
    expand = "none",
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      utils.colorize(menu, colors.white),
      screen.mytaglist,
      separator,
      screen.mypromptbox,
      separator,
      screen.mytasklist,
    },
    { -- Middle widgets
      layout = wibox.layout.fixed.horizontal,
      calendar
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      utils.colorize(cpu, colors.orange),
      separator,
      utils.colorize(ram, colors.green),
      separator,
      utils.colorize(uptime, colors.magenta),
      separator,
      utils.colorize(volume_widget, colors.red),
      separator,
      utils.colorize(keyboard_layout_widget, colors.yellow),
      separator,
      wibox.widget.systray(),
      screen.mylayoutbox
    },
  }
end

return setmetatable(custom_wibox, { __call = function(_, ...) return create(...) end })
