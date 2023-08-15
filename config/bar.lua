local utils = require("config.widgets.utils")
local kanagawa = require("kanagawa.theme").palette
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local custom_wibox = {}

local function create(screen)
  local separator = wibox.widget.textbox(" ")
  return {
    spacing = dpi(50),
    layout = wibox.layout.align.horizontal,
    expand = "none",
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      utils.colorize(require("config.widgets.menu"), kanagawa.border),
      screen.mytaglist,
      separator,
      screen.mypromptbox,
      separator,
      screen.mytasklist,
    },
    { -- Middle widgets
      layout = wibox.layout.fixed.horizontal,
      require("config.widgets.calendar")(screen, kanagawa.border)
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      utils.colorize(require("config.widgets.cpu"), kanagawa.orange),
      separator,
      utils.colorize(require("config.widgets.ram"), kanagawa.green),
      separator,
      utils.colorize(require("config.widgets.uptime"), kanagawa.magenta),
      separator,
      utils.colorize(volume_widget, kanagawa.red),
      separator,
      utils.colorize(keyboard_layout_widget, kanagawa.yellow),
      separator,
      wibox.widget.systray(),
      screen.mylayoutbox
    },
  }
end

return setmetatable(custom_wibox, { __call = function(_, ...) return create(...) end })
