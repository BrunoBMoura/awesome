-- https://bbs.archlinux.org/viewtopic.php?id=182862

local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local utils = require("config.widgets.utils")

-- Local widget information.
local PROC = {
  cmd = {
    "setxkbmap -model",
    "-layout"
  }
}

-- Builds the setxkbmap command with the given layout.
local function build_cmd(layout)
  return string.format("%s %s %s %s", PROC.cmd[1], layout, PROC.cmd[2], layout)
end

-- Keyboard layout module.
local keyboard_layout = {
  current = 1,
  layouts = {
    {
      name = "us",
      description = "English (US)"
    },
    {
      name = "br",
      description = "Portuguese (BR)"
    }
  }
}

keyboard_layout.create = function()
  local kbl_widget = wibox.widget.textbox()

  -- First, invoke the setxkbmap command to set the initial layout and set
  -- the widgets text accordingly.
  utils.invoke(
    build_cmd(keyboard_layout.layouts[keyboard_layout.current].name)
  )
  kbl_widget:set_text(
    string.format("Layout: %s", keyboard_layout.layouts[keyboard_layout.current].name)
  )

  -- Then, set the tooltip as the current layouts description text.
  utils.simple_tooltip({ kbl_widget }, function()
    return keyboard_layout.layouts[keyboard_layout.current].description
  end)

  -- Next, define the switch function, which will be called when the widget is clicked.
  kbl_widget.switch = function()
    keyboard_layout.current = keyboard_layout.current % #keyboard_layout.layouts + 1
    utils.invoke(
      build_cmd(keyboard_layout.layouts[keyboard_layout.current].name)
    )
    kbl_widget:set_text(
      string.format("Layout: %s", keyboard_layout.layouts[keyboard_layout.current].name)
    )
  end

  -- And finally, add the 'click event' to the widget with a simple button.
  kbl_widget:buttons(
    awful.util.table.join(
      awful.button({ }, 1, function()
        kbl_widget.switch()
    end)
    )
  )

  return kbl_widget
end

return keyboard_layout
