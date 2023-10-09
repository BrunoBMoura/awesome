local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

local vol_sli = wibox.widget ({
  widget = wibox.widget.slider,
  maximum = 100,
  forced_height = dpi(10),
  bar_height = dpi(2),
  bar_color = beautiful.palette.green,
  handle_width = dpi(30),
  handle_border_width = dpi(5),
  handle_margins = { top = 1, bottom = 1 },
  handle_shape = gears.shape.square,
  handle_color = beautiful.palette.green,
  handle_border_color = beautiful.palette.black,
})

local vol_ico = wibox.widget {
  widget = wibox.widget.textbox,
  markup = " ",
  align = "center",
  font = USER.font(15),
}

local vol_perc = wibox.widget {
  widget = wibox.widget.textbox,
  align = "center",
}

local vol = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  -- fill_space = true,
  spacing = dpi(1),
  vol_ico,
  {
    vol_sli,
    widget = wibox.container.background,
    forced_width = dpi(150),
    forced_height = 10
  },
  vol_perc
}

vol_sli.value = 25
vol_perc.markup = "25%"

return vol
