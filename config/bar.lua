local utils = require("config.widgets.utils")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local colors = USER.palette
local custom_wibox = {}

local function create(screen)
  local separator = wibox.widget.textbox(" ")
  return {
    spacing = dpi(50),
    layout = wibox.layout.align.horizontal,
    expand = "none",
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      utils.colorize(require("config.widgets.menu"), colors.cyan),
      screen.mytaglist,
      separator,
      screen.mypromptbox,
      separator,
      screen.mytasklist,
    },
    { -- Middle widgets
      layout = wibox.layout.fixed.horizontal,
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      utils.colorize(require("config.widgets.cpu"), colors.orange),
      separator,
      utils.colorize(require("config.widgets.ram"), colors.green),
      separator,
      utils.colorize(require("config.widgets.uptime"), colors.magenta),
      separator,
      utils.colorize(volume_widget, colors.red),
      separator,
      utils.colorize(keyboard_layout_widget, colors.yellow),
      separator,
      require("config.widgets.calendar")(screen, colors.cyan),
      separator,
      wibox.widget.systray(),
      screen.mylayoutbox
    },
  }
end

return setmetatable(custom_wibox, { __call = function(_, ...) return create(...) end })
