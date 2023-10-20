local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local colors = beautiful.palette

-- helpers module.
local M = {}

-- Notifies the given text.
M.notify = function(text)
  local info = debug.getinfo(1, "Sl")
  naughty.notify({
    title = "::Assert::",
    text = string.format(
      "Called from (%s, %s): %s", info.short_src, info.currentline, tostring(text)
    )
  })
end

-- Builds a match string for the given number of occurrences or numerical values.
M.build_match_for = function(occurrences)
  local match = "(%d+)"
  for _ = 1, occurrences - 1 do
    match = match .. "%s+(%d+)"
  end
  return match
end

-- Colorizes the given widget with the given colors.
M.colorize = function(widget, foreground_color, background_color)
  local fg = foreground_color or beautiful.fg_normal
  local bg = background_color or beautiful.bg_normal
  return wibox.widget({
    {
      widget,
      bg = bg,
      fg = fg,
      widget = wibox.container.background
    },
    layout = wibox.layout.fixed.horizontal
  })
end

-- Creates a tooltip for the given widgets table.
M.simple_tooltip = function(widgets_tbl, callback)
  awful.tooltip({
    objects = widgets_tbl,
    mode = "outside",
    align = "right",
    timer_function = callback,
    preferred_positions = { "bottom", "center" },
    margin_leftright = dpi(15),
    margin_topbottom = dpi(15),
    border_width = dpi(1),
    bg = beautiful.bg_normal,
  })
end

-- Creates a simple textbox widget with default configurations.
M.simple_textbox = function(opts)
  opts = opts or {}
  local font = opts.font or beautiful.font
  return wibox.widget({
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    font = font
  })
end

-- Underlines a given widget.
M.underlined = function(widget, underline_color)
  local underline = wibox.widget({
    widget        = wibox.widget.separator,
    orientation   = "horizontal",
    forced_height = dpi(1),
    forced_width  = dpi(25),
    color         = underline_color,
  })

  return wibox.widget({
    {
      widget,
      layout = wibox.layout.stack,
    },
    {
      underline,
      top = dpi(28),
      layout = wibox.container.margin,
    },
    layout = wibox.layout.stack,
  })
end

-- Creates a box for the given widget.
M.box = function(widget, opts)
  opts = opts or {}
  local fg = opts.foreground_color or beautiful.fg_normal
  local bg = opts.background_color or beautiful.bg_normal
  local margin = opts.margin or dpi(5)
  local radius = opts.radius or dpi(5)
  local shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end

  return wibox.widget({
    {
      widget,
      bg = bg,
      fg = fg,
      -- shape = shape,
      widget = wibox.container.background
    },
    margins = margin,
    widget = wibox.container.margin
  })
end

-- Creates an arc widget with a text box inside it.
M.arc = function(bg, thickness, text)
  local text_box = M.simple_textbox({ font = USER.font(20) })
  text_box:set_text(string.format("%s%s", text, "0%" ))

  return wibox.widget({
    text_box,
    id = "text",
    max_value = 100,
    min_value = 0,
    thickness = thickness,
    start_angle = 4.71238898, -- 2pi*3/4
    forced_height = dpi(150),
    forced_width = dpi(150),
    border_width = dpi(1),
    border_color = bg,
    bg = bg,
    colors = { USER.palette.grey },
    widget = wibox.container.arcchart
  })
end

-- Creates an slider widget for ui controls. It also provides a simple
-- single method on it for its value update.
M.slider_widget = function(text_icon, color)
  local slider = wibox.widget({
    widget = wibox.widget.slider,
    maximum = 100,
    forced_height = dpi(10),
    bar_height = dpi(2),
    bar_color = color,
    handle_width = dpi(30),
    handle_border_width = dpi(5),
    handle_margins = { top = dpi(1), bottom = dpi(1) },
    handle_shape = gears.shape.square,
    handle_color = colors.white,
    handle_border_color = colors.grey,
  })

  local icon = wibox.widget({
    widget = wibox.widget.textbox,
    markup = text_icon,
    align = "center",
    font = USER.font(15),
  })

  local percentage = wibox.widget({
    widget = wibox.widget.textbox,
    align = "center",
  })

  local final_widget = wibox.widget({
    layout = wibox.layout.fixed.horizontal,
    fill_space = true,
    spacing = dpi(1),
    icon,
    {
      slider,
      widget = wibox.container.background,
      forced_width = dpi(380),
      forced_height = dpi(25)
    },
    percentage
  })

  final_widget.set_value = function(_, value)
    slider.value = value
    percentage.markup = value .. "%"
  end

  return final_widget
end

M.button = function(opts)
  opts = opts or {}
  local text = opts.text or "Button"
  local bg = opts.background_color or beautiful.background_alt
  local fg = opts.foreground_color or beautiful.fg_normal

  local widget = wibox.widget({
    widget = wibox.container.background,
    bg = bg,
    fg = fg,
    {
      widget = wibox.widget.textbox,
      text = text ,
      font = USER.font(15),
    }
  })

  return widget
end

M.popup_menu = function(opts)
  -- Proper widget to hold the options of the powermenu.
  local options_container = wibox.widget({
    homogeneous = false,
    expand = true,
    forced_num_cols = 3,
    spacing = dpi(10),
    layout = wibox.layout.grid
  })

  -- Prompt use to get the user input.
  local prompt = wibox.widget({
    widget = wibox.widget.textbox,
    visible = false
  })

  -- Main widget to properly hold both the prompt and the options.
  local main_widget = wibox.widget({
    widget = wibox.container.margin,
    margins = dpi(10),
    {
      layout = wibox.layout.fixed.vertical,
      prompt,
      options_container
    }
  })

  -- Toggleable popup widget.
  local popup_widget = awful.popup({
    visible = false,
    ontop = true,
    bg = beautiful.palette.background,
    border_color = beautiful.palette.grey,
    border_width = dpi(1),
    placement = function(d)
      awful.placement.centered(d)
    end,
    widget = main_widget
  })

  -- Add the options to the options container.
  for _, option in ipairs(opts) do
    local option_widget = wibox.widget({
      widget = wibox.container.background,
      forced_width = dpi(100),
      forced_height = dpi(100),
      buttons = {
        awful.button({}, 1, function ()
          M.notify("Power Menu" .. option.name)
        end)
      },
      {
        widget = wibox.widget.textbox(),
        fg = beautiful.fg_normal,
        align = "center",
        font = USER.font(40),
        markup = option.text,
      },
    })
    -- Forcefully set the id of the option widget to the option name. This is
    -- done so that the widget can be properly accessed later on by _get_children_by_id().
    option_widget.id = option.name
    options_container:add(option_widget)
  end

  -- Now, additional abstraction functions are added to the popup
  -- widget so that it can be properly interacted with.

  -- Set the current cell index being accesed.
  popup_widget.current_index = 1

  -- Custom ID verification function, probably can be equally done using only the
  -- get_children_by_id method if widgets are correctly placed.
  popup_widget._get_children_by_id = function(_, id)
    for _, option in ipairs(options_container:get_children()) do
      if option.id == id then
        return option
      end
    end
  end

  -- Readability enhancement.
  popup_widget._current = function(self)
    local current_id = opts[self.current_index].name
    return self:_get_children_by_id(current_id)
  end

  -- Custom option function to properly change the current index and highlight
  -- of the current cell.
  popup_widget._option = function(self, operation)
    -- First, define the index adjustment for each operation.
    local index_adjust = {
      ["next"] = function()
        self.current_index = self.current_index % #opts + 1
      end,
      ["prev"] = function()
        self.current_index = self.current_index - 1
        if self.current_index == 0 then
          self.current_index = #opts
        end
      end
    }

    -- Access the current option and set its background to the default one.
    self:_current().bg = beautiful.background
    -- Perform the index adjustment.
    index_adjust[operation]()
    -- Access the new current option and set its background to the highlighted one.
    self:_current().bg = beautiful.palette.grey
  end

  -- Method called to run the prompt and capture user key presses.
  popup_widget._run = function(self)
    awful.prompt.run({
      textbox = prompt,
      exe_callback = function()
        -- Properly execute the command here.
        M.notify(opts[self.current_index].command)
      end,
      keypressed_callback = function(_, key)
        local operation = {
          ["Right"] = function() self:_option("next") end,
          ["Left"] = function() self:_option("prev") end,
          ["l"] = function() self:_option("next") end,
          ["h"] = function() self:_option("prev") end
        }

        -- If any other key is pressed while the prompt is running, do nothing.
        if operation[key] == nil then
          return
        end
        operation[key]()
      end,
      done_callback = function()
        self.visible = false
      end
    })
  end

  -- Toggle function to show/hide the popup widget.
  popup_widget.toggle = function(self)
    if self.visible then
      self.visible = false
      return
    end
    self.visible = true
    self:_current().bg = beautiful.palette.grey
    self:_run()
  end

  return popup_widget
end

return M
