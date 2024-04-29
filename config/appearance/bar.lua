local helpers = require("config.helpers")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local colors = beautiful.palette
local custom_wibox = {}

local function create(screen)
  local separator = wibox.widget.textbox(" ")
  local menu = require("config.appearance.widgets.menu")({ text = "", font_size = 15 })
  local date = require("config.appearance.widgets.date")({
    icon = " 󰃰", color = colors.white
  })
  local uptime = require("config.appearance.widgets.uptime")({ icon = " 󰚰 "})

  return {
    spacing = dpi(50),
    layout = wibox.layout.align.horizontal,
    expand = "none",
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      helpers.box(menu),
      screen.mytaglist,
      separator,
      screen.mytasklist,
      separator,
      screen.mypromptbox,
    },
    { -- Middle widgets
      layout = wibox.layout.fixed.horizontal,
      -- helpers.box(date, { background_color = colors.grey }),
      helpers.box(date),
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      helpers.box(uptime),
      helpers.box(VOLUME_WIDGET),
      helpers.box(KEYBOARD_LAYOUT_WIDGET),
      helpers.box(BATT_WIDGET),
      wibox.widget.systray(),
      screen.mylayoutbox
    },
  }
end

return setmetatable(custom_wibox, { __call = function(_, ...) return create(...) end })
