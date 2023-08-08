-- https://bbs.archlinux.org/viewtopic.php?id=182862

local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local keyboard_layout = {}

keyboard_layout.create = function()
  local kbl_widget = awful.widget.keyboardlayout()

  awful.tooltip({
    objects = { kbl_widget },
    mode = "outside",
    align = "right",
    timer_function = function()
       return "Current keyboard layout."
    end,
    preferred_positions = { "bottom", "center" },
    margin_leftright = dpi(15),
    margin_topbottom = dpi(15)
  })

  return kbl_widget
end

return keyboard_layout
