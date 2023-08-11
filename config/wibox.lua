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
      screen.mytaglist,
      separator,
      screen.mypromptbox,
      screen.mytasklist,
    },
    { -- Middle widgets
      layout = wibox.layout.fixed.horizontal,
      utils.underlined(require("config.widgets.calendar")(screen), kanagawa.border),
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      utils.underlined(require("config.widgets.ram"), kanagawa.green),
      separator,
      utils.underlined(volume_widget, kanagawa.red),
      separator,
      utils.underlined(keyboard_layout_widget, kanagawa.yellow),
      separator,
      utils.underlined(require("config.widgets.uptime"), kanagawa.magenta),
      separator,
      wibox.widget.systray(),
      screen.mylayoutbox
    },
  }
end

return setmetatable(custom_wibox, { __call = function(_, ...) return create(...) end })
