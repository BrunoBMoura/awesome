local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local audio = require("config.widgets.control_center.audio")
local utils = require("config.widgets.utils")
local colors = USER.palette

local mem = utils.arc(
  beautiful.palette.blue, beautiful.palette.grey, dpi(8), "Mem", " "
)

local cpu = utils.arc(
  beautiful.palette.green, beautiful.palette.grey, dpi(8), "Cpu", " "
)

local storage = utils.arc(
  beautiful.palette.red, beautiful.palette.grey, dpi(8), "Storage", " "
)

local resources = wibox.widget({
  layout = wibox.layout.fixed.horizontal,
  spacing = dpi(10),
})

local main_widget = wibox.widget {
  layout = wibox.layout.fixed.vertical,
  spacing = dpi(10),
}

resources:add(cpu, mem, storage)

local resources_widget = utils.box(resources, {
  -- bg = beautiful.background,
  background_color = colors.grey,
  margins = dpi(15),
})

local popup_widget = awful.popup({
  visible = false,
  ontop = true,
  border_width = dpi(1),
  border_color = beautiful.palette.grey,
  placement = function(d)
    awful.placement.top_right(d, { honor_workarea = true, margins = dpi(6) })
  end,
  widget = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.background,
    forced_width = dpi(500),
    {
      widget = wibox.container.margin,
      margins = dpi(10),
      main_widget,
    }
  }
})

awesome.connect_signal("toggle::control_center", function()
  if popup_widget.visible then
    popup_widget.visible = false
  else
    main_widget:reset()
    main_widget:add(resources_widget, audio.speaker, audio.mic)
    popup_widget.visible = true
  end
end)
