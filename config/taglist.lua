local awful = require("awful")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

-- Define the taglist module
local taglist = {}

local function create(screen, buttons)
  return awful.widget.taglist({
    screen  = screen,
    filter  = awful.widget.taglist.filter.all,
    buttons = buttons,
    layout = {
      spacing = dpi(5),
      layout = wibox.layout.fixed.horizontal
    },
    widget_template = {
      {
        {
          {
            id = 'text_role',
            widget = wibox.widget.textbox
          },
          layout = wibox.layout.fixed.horizontal,
        },
        left = dpi(12),
        right = dpi(12),
        widget = wibox.container.margin
      },
      id = 'background_role',
      widget = wibox.container.background,
    },
  })
end

return setmetatable(taglist, { __call = function(_, ...) return create(...) end })
