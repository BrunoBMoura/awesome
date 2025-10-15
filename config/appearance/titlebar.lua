local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local M = {}

local function titlebar_button(opts)
  local button = wibox.widget({
    {
      {
        id = "button_text_box",
        text = opts.text or "󰝤 ",
        font = USER.font(14),
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
      },
      id = "button_text_box_container",
      fg = opts.color or USER.palette.blue,
      widget = wibox.container.background
    },
    buttons = gears.table.join(
      awful.button({}, 1, function()
        if opts.click_function then
          opts.click_function()
        end
      end)
    ),
    layout = wibox.layout.align.vertical
  })

  local button_container = button:get_children_by_id("button_text_box_container")[1]
  local initial_color = button_container.fg
  button:connect_signal("mouse::enter", function()
    button_container.fg = USER.palette.white
  end)

  button:connect_signal("mouse::leave", function()
    button_container.fg = initial_color
  end)

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
      titlebar_button({
        color = USER.palette.blue,
        text = "󱂬 ",
        tooltip = "Float",
        click_function = function()
          c.floating = not c.floating
        end
      }),
      titlebar_button({
        color = USER.palette.green,
        text = "󰘖 ",
        tooltip = "Mazimize",
        click_function = function()
          c.maximized = not c.maximized
          c:raise()
        end
      }),
      titlebar_button({
        color = USER.palette.yellow,
        text = "󰘕 ",
        tooltip = "Minimize",
        click_function = function()
          awful.client.focus.history.previous()
          c.minimized = true
        end
      }),
      titlebar_button({
        color = USER.palette.red,
        text = "󰖭 ",
        tooltip = "Close",
        click_function = function()
          c:kill()
        end
      }),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal,
  })
end

return M
