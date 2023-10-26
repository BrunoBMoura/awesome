local helpers = require("config.widgets.helpers")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local colors = beautiful.palette
local custom_wibox = {}

local function create(screen)
  local separator = wibox.widget.textbox(" ")
  local menu = require("config.widgets.menu")({ text = "", font_size = 15 })
  local date = require("config.widgets.date")({
    icon = " 󰃰", color = colors.white
  })
  local uptime = require("config.widgets.uptime")({ icon = " 󰚰 "})

  return {
    spacing = dpi(50),
    layout = wibox.layout.align.horizontal,
    expand = "none",
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      helpers.colorize(menu, colors.white, colors.grey),
      screen.mytaglist,
      separator,
      screen.mytasklist,
      separator,
      screen.mypromptbox,
    },
    { -- Middle widgets
      layout = wibox.layout.fixed.horizontal,
      helpers.box(date, { background_color = colors.grey }),
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      helpers.box(uptime, { background_color = colors.grey }),
      helpers.box(volume_widget, { background_color = colors.grey }),
      helpers.box(keyboard_layout_widget, { background_color = colors.grey }),
      wibox.widget.systray(),
      screen.mylayoutbox
    },
  }
end

return setmetatable(custom_wibox, { __call = function(_, ...) return create(...) end })
