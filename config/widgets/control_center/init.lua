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

local calendar = require("config.widgets.control_center.calendar")
  -- icon = " ",

local calendar_widget = boxfy(wibox.layout.fixed.vertical, { calendar })

local mem = require("config.widgets.control_center.ram")({
  icon = " ",
  color = colors.blue,
})

local cpu = require("config.widgets.control_center.cpu")({
  icon = " ",
  color = colors.green,
})

local storage = require("config.widgets.control_center.disk")({
  icon = " ",
  device = USER.device,
  color = colors.orange,
})

local resources_widget = boxfy(wibox.layout.flex.horizontal, { cpu, mem, storage })

local audio = require("config.widgets.control_center.audio")({
  speaker = {
    icon = "  ",
    color = beautiful.palette.green,
  },
  mic = {
    icon = "  ",
    color = beautiful.palette.orange,
  },
})

local audio_widget = boxfy(wibox.layout.fixed.vertical, { audio.speaker, audio.mic })

local main_widget = wibox.widget({
  layout = wibox.layout.fixed.vertical,
  spacing = dpi(2),
})

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

awesome.connect_signal("toggle::control_center", function()
  if popup_widget.visible then
    popup_widget.visible = false
  else
    main_widget:reset()
    main_widget:add(calendar_widget, resources_widget, audio_widget)
    popup_widget.visible = true
  end
end)
