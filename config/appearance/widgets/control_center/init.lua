local wibox = require("wibox")
local awful = require("awful")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("config.helpers")
local beautiful = require("beautiful")
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

local function create()
  -- Require the clock widget and wrap it inside a box.
  local clock = require("config.appearance.widgets.control_center.clock")()
  local clock_widget = boxfy(wibox.layout.fixed.vertical, { clock })

  -- Also, require the calendar widget and wrap it inside a box.
  local calendar = require("config.appearance.widgets.control_center.calendar")
  local calendar_widget = boxfy(wibox.layout.fixed.vertical, { calendar })

  -- For the resource widgets, require them one by one then wrap them in a single box.
  local ram = require("config.appearance.widgets.control_center.ram")({
    text = " ", color = colors.green,
  })

  local cpu = require("config.appearance.widgets.control_center.cpu")({
    text = " ", color = colors.blue,
  })

  local disk = require("config.appearance.widgets.control_center.disk")({
    text = " 󰋊 ", device = USER.device, color = colors.orange,
  })

  local resources_widget = boxfy(wibox.layout.flex.horizontal, { cpu, ram, disk })

  -- Require the audio widgets and wrap them inside a single box as well.
  local audio = require("config.appearance.widgets.control_center.audio")({
    speaker = { color = beautiful.palette.green, value = 25 },
    mic = { color = beautiful.palette.orange, value = 45 },
  })

  local audio_widget = boxfy(wibox.layout.fixed.vertical, { audio.speaker, audio.mic })

  -- Define the proper control center widget.
  local control_center = {}

  -- For the main widget, simply declare it as vertical layout.
  control_center.main = wibox.widget({
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(2),
  })

  -- Define a popup widget to contain the main widget that will be used as the real
  -- control center.
  control_center.popup = awful.popup({
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
        control_center.main,
      }
    })
  })

  -- Then, add the widgets to the main widget.
  local sections = {
    clock_widget,
    calendar_widget,
    resources_widget,
    audio_widget,
  }

  if USER.portable then
    local brightness = require("config.appearance.widgets.control_center.brightness")({
      color = beautiful.palette.yellow,
      value = 30
    })
    local brightness_widget = boxfy(wibox.layout.fixed.vertical, { brightness })
    table.insert(sections, brightness_widget)
  end

  for _, section in ipairs(sections) do
    control_center.main:add(section)
  end

  -- Finally, define the control center toggle function to be called
  -- upon signal receival.
  control_center.toggle = function(self)
    if self.popup.visible then
      self.popup.visible = false
      return
    end
    self.popup.visible = true
  end

  return control_center
end

return create()
