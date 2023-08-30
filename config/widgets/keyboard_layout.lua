local awful = require("awful")
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
local keyboard = {
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

local function worker(opts)
  opts = opts or {}
  local icon = opts.icon or ""
  keyboard.widget = utils.simple_textbox()

  -- First, invoke the setxkbmap command to set the initial layout and set
  -- the widgets text accordingly.
  awful.spawn.easy_async(build_cmd(keyboard.layouts[keyboard.current].name))
  keyboard.widget:set_text(string.format("%s%s", icon, keyboard.layouts[keyboard.current].name))

  -- Then, set the tooltip as the current layouts description text.
  utils.simple_tooltip({ keyboard.widget }, function()
    return keyboard.layouts[keyboard.current].description
  end)

  -- Next, define the switch function, which will be called when the widget is clicked.
  keyboard.widget.switch = function()
    keyboard.current = keyboard.current % #keyboard.layouts + 1
    awful.spawn.easy_async(build_cmd(keyboard.layouts[keyboard.current].name))
    keyboard.widget:set_text(string.format("%s%s", icon, keyboard.layouts[keyboard.current].name))
  end

  -- And finally, add the 'click event' to the widget with a simple button.
  keyboard.widget:buttons(awful.button({ }, 1, function()
      keyboard.widget:switch()
    end)
  )

  return keyboard.widget
end

return setmetatable(keyboard, { __call = function(_, ...) return worker(...) end })
