local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("config.widgets.helpers")
local colors = beautiful.palette

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
    background_color = colors.grey,
    foreground_color = beautiful.fg_normal,
  })
end

-- Require the clock widget and wrap it inside a box.
local clock = require("config.widgets.control_center.clock")({})

local clock_widget = boxfy(wibox.layout.fixed.vertical, { clock })

-- Also, require the calendar widget and wrap it inside a box.
local calendar = require("config.widgets.control_center.calendar")

local calendar_widget = boxfy(wibox.layout.fixed.vertical, { calendar })

-- For the resource widgets, require them one by one then wrap them in a single box.
local ram = require("config.widgets.control_center.ram")({
  text = " ", color = colors.blue,
})

local cpu = require("config.widgets.control_center.cpu")({
  text = " ", color = colors.green,
})

local disk = require("config.widgets.control_center.disk")({
  text = " ", device = USER.device, color = colors.orange,
})

local resources_widget = boxfy(wibox.layout.flex.horizontal, { cpu, ram, disk })

-- Require the audio widgets and wrap them inside a single box as well.
local audio = require("config.widgets.control_center.audio")({
  speaker = { text = "  ", color = beautiful.palette.green },
  mic = { text = "  ", color = beautiful.palette.orange },
})

local audio_widget = boxfy(wibox.layout.fixed.vertical, { audio.speaker, audio.mic })

-- For the main widget, simply declare it as vertical layout.
local main_widget = wibox.widget({
  layout = wibox.layout.fixed.vertical,
  spacing = dpi(2),
})

-- Define a popup widget to contain the main widget that will be used as the real
-- control center.
local popup_widget = awful.popup({
  visible = false,
  ontop = true,
  border_width = dpi(1),
  border_color = beautiful.palette.grey,
  placement = function(d)
    awful.placement.top_right(d, { honor_workarea = true, margins = dpi(6) })
  end,
  widget = wibox.widget({
    widget = wibox.container.background,
    bg = beautiful.background,
    forced_width = dpi(500),
    {
      widget = wibox.container.margin,
      margins = dpi(5),
      main_widget,
    }
  })
})

-- Finally, connect the 'toggle::control_center' signal to the popup widget;
-- this will be used to toggle its visibility.
awesome.connect_signal("toggle::control_center", function()
  if popup_widget.visible then
    popup_widget.visible = false
  else
    -- Whenever the popup widget is to be shown, reset the main widget to its default
    -- state, add to it all the previously defined widgets and set it as visible.
    main_widget:reset()
    main_widget:add(
      clock_widget,
      calendar_widget,
      resources_widget,
      audio_widget
    )
    popup_widget.visible = true
  end
end)
