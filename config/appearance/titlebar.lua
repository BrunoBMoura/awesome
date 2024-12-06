local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local M = {}

local function titlebar_button(color, tooltip, click_function)
  local button = wibox.widget({
    {
      {
        text = "󰝤 ",
        font = USER.font(14),
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
      },
      fg = color,
      widget = wibox.container.background
    },
    buttons = gears.table.join(
      awful.button({}, 1, function()
        click_function()
      end)
    ),
    layout = wibox.layout.align.vertical
  })

  return button
end

M.setup_titlebar = function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({}, 1, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.resize(c)
    end)
  )

  local titlebar = awful.titlebar(c, {
    bg = USER.palette.background
  })

  titlebar:setup({
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      -- layout  = wibox.layout.fixed.horizontal,
      top = dpi(3),
      bottom = dpi(3),
      left = dpi(3),
      widget = wibox.container.margin
    },
    { -- Middle
      { -- Title
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c),
        font = USER.font(8)
      },
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal
    },
    { -- Right
      titlebar_button(USER.palette.green, "Maximize", function()
        c.maximized = not c.maximized
        c:raise()
      end),
      titlebar_button(USER.palette.yellow, "Minimize", function()
        -- somehow not working as intended
        c.minimized = true
      end),
      titlebar_button(USER.palette.red, "Close", function()
        c:kill()
      end),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal,
  })
end

return M
