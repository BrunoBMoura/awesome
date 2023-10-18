local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("config.widgets.helpers")

-- Simple helper function to boxfy widgets inside a single shape
-- keeping the spacing and marging consistent.
local function boxfy(layout, widgets_tbl)

  local main_widget = wibox.widget({
    layout = layout,
    spacing = dpi(1),
  })

  for _, widget in ipairs(widgets_tbl) do
    main_widget:add(widget)
  end

  return helpers.box(main_widget, {
    margin = dpi(5),
    background_color = beautiful.palette.grey,
    foreground_color = beautiful.fg_normal,
  })
end

local mem = require("config.widgets.control_center.ram")({
  icon = " ",
  color = beautiful.palette.blue,
})

local cpu = require("config.widgets.control_center.cpu")({
  icon = " ",
  color = beautiful.palette.green,
})

local storage = helpers.arc(
  beautiful.palette.red, dpi(12), " "
)
storage.value = 50

local resources_widget = boxfy(wibox.layout.flex.horizontal, { cpu, mem, storage })

local audio = require("config.widgets.control_center.audio")
local audio_widget = boxfy(wibox.layout.fixed.vertical, { audio.speaker, audio.mic })

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

awesome.connect_signal("toggle::control_center", function()
  if popup_widget.visible then
    popup_widget.visible = false
  else
    main_widget:reset()
    main_widget:add(resources_widget, audio_widget)
    popup_widget.visible = true
  end
end)
