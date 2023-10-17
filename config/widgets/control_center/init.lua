local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local audio = require("config.widgets.control_center.audio")
local utils = require("config.widgets.utils")

local mem = utils.arc(
  beautiful.palette.blue, dpi(12), "Mem", " "
)

mem.value = 50

local cpu = utils.arc(
  beautiful.palette.green, dpi(12), "Cpu", " "
)

cpu.value = 25

local storage = utils.arc(
  beautiful.palette.red, dpi(12), "Disk", " "
)

storage.value = 75

local resources = wibox.widget({
  layout = wibox.layout.flex.horizontal,
  spacing = dpi(1),
})

resources:add(cpu, mem, storage)

local resources_widet_box = utils.box(resources, {
  margin = dpi(5),
  background_color = beautiful.palette.grey,
  foreground_color = beautiful.fg_normal,
})


local main_widget = wibox.widget {
  layout = wibox.layout.fixed.vertical,
  spacing = dpi(2),
}

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
      margins = dpi(5),
      main_widget,
    }
  }
})

local audio_widget = wibox.widget({
  layout = wibox.layout.fixed.vertical,
  spacing = dpi(1),
  audio.speaker,
  audio.mic,
})

local audio_widget_box = utils.box(audio_widget, {
  margin = dpi(5),
  background_color = beautiful.palette.grey,
})

awesome.connect_signal("toggle::control_center", function()
  if popup_widget.visible then
    popup_widget.visible = false
  else
    main_widget:reset()
    main_widget:add(resources_widet_box, audio_widget_box)
    popup_widget.visible = true
  end
end)
