local helpers = require("config.widgets.helpers")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

local colors = USER.palette
local custom_wibox = {}

local function create(screen)
  local separator = wibox.widget.textbox(" ")
  local menu = require("config.widgets.menu")({ icon = "", font_size = 15 })
  local date = require("config.widgets.date")({
    icon = "󰃰", color = colors.white
  })
  local uptime = require("config.widgets.uptime")({ icon = "󰚰 "})

  return {
    spacing = dpi(50),
    layout = wibox.layout.align.horizontal,
    expand = "none",
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      helpers.colorize(menu, colors.white, colors.grey),
      screen.mytaglist,
      separator,
      screen.mypromptbox,
      separator,
      screen.mytasklist,
    },
    { -- Middle widgets
      layout = wibox.layout.fixed.horizontal,
      date,
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      uptime,
      separator,
      volume_widget,
      separator,
      keyboard_layout_widget,
      separator,
      wibox.widget.systray(),
      screen.mylayoutbox
    },
  }
end

return setmetatable(custom_wibox, { __call = function(_, ...) return create(...) end })
