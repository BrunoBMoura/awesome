local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Define the tasklist module
local tasklist = {}

local function create(screen, buttons)
  return awful.widget.tasklist({
    screen   = screen,
    filter   = awful.widget.tasklist.filter.currenttags,
    buttons  = buttons,
    layout   = {
      spacing_widget = {
        {
          forced_width  = dpi(5),
          forced_height = dpi(25),
          thickness     = dpi(2),
          color         = beautiful.bg_focus,
          widget        = wibox.widget.separator
        },
        valign = 'center',
        halign = 'center',
        widget = wibox.container.place,
      },
      spacing = dpi(5),
      layout  = wibox.layout.fixed.horizontal
    },
    widget_template = {
      {
        wibox.widget.base.make_widget(),
        forced_height = dpi(2),
        forced_width  = dpi(1),
        id            = 'background_role',
        widget        = wibox.container.background,
      },
      {
        {
          id     = 'clienticon',
          widget = awful.widget.clienticon,
        },
        margins = dpi(5),
        widget  = wibox.container.margin
      },
      nil,
      create_callback = function(self, c, _, _)
        self:get_children_by_id('clienticon')[1].client = c
      end,
      layout = wibox.layout.align.vertical,
    },
  })
end

return setmetatable(tasklist, { __call = function(_, ...) return create(...) end })
