local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local colors = USER.palette

local function create(text_icon, color)
  local slider = wibox.widget({
    widget = wibox.widget.slider,
    maximum = 100,
    forced_height = dpi(10),
    bar_height = dpi(2),
    bar_color = color,
    handle_width = dpi(30),
    handle_border_width = dpi(5),
    handle_margins = { top = dpi(1), bottom = dpi(1) },
    handle_shape = gears.shape.square,
    handle_color = beautiful.palette.white,
    handle_border_color = beautiful.palette.grey,
  })

  local icon = wibox.widget({
    widget = wibox.widget.textbox,
    markup = text_icon,
    align = "center",
    font = USER.font(15),
  })

  local percentage = wibox.widget({
    widget = wibox.widget.textbox,
    align = "center",
  })

  local final_widget = wibox.widget({
    layout = wibox.layout.fixed.horizontal,
    fill_space = true,
    spacing = dpi(1),
    icon,
    {
      slider,
      widget = wibox.container.background,
      forced_width = dpi(380),
      forced_height = dpi(25)
    },
    percentage
  })

  slider.value = 25
  percentage.markup = "25%"

  return final_widget
end

local vol = create("  ", colors.green)
local mic = create("  ", colors.yellow)

return { speaker = vol, mic = mic }
