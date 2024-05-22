local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local colors = beautiful.palette

-- helpers module.
local M = {}

-- Helper function to spawn a command and capture its output, mostly
-- used by widget modules.
M.spawn_and_capture = function(command, capture_callback)
  return awful.spawn.easy_async(command, capture_callback)
end

-- Helper function to simply spawn a command, mostly used by widget modules.
M.simple_spawn = function(command)
  return awful.spawn.with_shell(command)
end

M.extract_numbers = function(input)
  local numbers = {}
  for number in string.gmatch(input, "[-+]?%d*%.?%d+") do
    table.insert(numbers, tonumber(number))
  end
  return numbers
end

-- Notifies the given text.
M.notify = function(text)
  local info = debug.getinfo(1, "Sl")
  naughty.notify({
    title = "::Assert::",
    text = string.format(
      "Called from (%s, %s): %s", info.short_src, info.currentline, tostring(text)
    ),
    border_color = USER.palette.orange
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
    border_color = beautiful.palette.grey,
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
  local text_box = M.simple_textbox({ font = USER.font(18) })
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

  -- Helper function to set all of the widgets values.
  final_widget.set_value = function(_, value)
    slider.value = value
    percentage.markup = value .. "%"
  end

  -- Helper function to connect a function to be called upon redraw
  -- of the slider widget with its new value as argument.
  final_widget.connect_function_upon_redraw = function(self, callback)
    slider:connect_signal("widget::redraw_needed", function()
      self:set_value(slider.value)
      callback(slider.value)
    end)
  end

  return final_widget
end

-- Creates a button widget with a text box inside it as the buttons icon.
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

--[[
  Crates a dynamic popup menu widget based on its arguments.
  The opts argument is a table of tables with the following structure:
   opts = {
     { name = "", command = "", text = "" },
     { name = "", command = "", text = "" },
   }
  In which the name field contains the name of the operation, the command
  field contains the command to be executed and the text field contains the
  text to be displayed on the option.
]]
M.popup_menu = function(opts)
  -- Proper widget to hold the options of the powermenu.
  local options_container = wibox.widget({
    homogeneous = false,
    expand = true,
    forced_num_cols = #opts,
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

  -- Custom function to get the index of the current cell being accessed.
  -- Used to allow mouse interaction on hover.
  popup_widget._get_idx_by_id = function(_, id)
    for idx, option in ipairs(options_container:get_children()) do
      if option.id == id then
        return idx
      end
    end
  end

  -- Readability enhancement.
  popup_widget._current = function(self)
    local current_id = opts[self.current_index].name
    return self:_get_children_by_id(current_id)
  end

  -- Custom option function to properly change the current index and highlight
  -- of the current cell. It also provide support for complex selections such
  -- as mouse hovering with the @meta_opts argument.
  popup_widget._select = function(self, operation, meta_opts)
    meta_opts = meta_opts or {}
    -- First, define the index adjustment for each operation.
    -- By default ignore the passed meta_opts argument.
    local index_adjust = {
      ["next"] = function(_)
        -- Circularly set the next index.
        self.current_index = self.current_index % #opts + 1
      end,
      ["prev"] = function(_)
        -- Circularly set the previous index.
        self.current_index = self.current_index - 1
        if self.current_index == 0 then
          self.current_index = #opts
        end
      end,
      ["hover"] = function(hover_opts)
        -- Upon mouse hover, set the current index to the hovered option.
        self.current_index = self:_get_idx_by_id(hover_opts.hovered_id)
      end
    }

    -- Access the current option and set its background to the default one.
    self:_current().bg = beautiful.background
    -- Perform the index adjustment.
    index_adjust[operation](meta_opts)
    -- Access the new current option and set its background to the highlighted one.
    self:_current().bg = beautiful.palette.grey
  end

  -- Custom function to properly execute the current command.
  popup_widget._exec_current = function(self)
    local command = opts[self.current_index].command
    awful.spawn.with_shell(command)
  end

  -- Method called to run the prompt and capture user key presses.
  popup_widget._run = function(self)
    awful.prompt.run({
      textbox = prompt,
      exe_callback = function()
        -- Properly execute the command here.
        self:_exec_current()
      end,
      keypressed_callback = function(_, key)
        local operation = {
          ["Right"] = function() self:_select("next") end,
          ["Left"]  = function() self:_select("prev") end,
          ["l"]     = function() self:_select("next") end,
          ["h"]     = function() self:_select("prev") end
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

  -- Connect the mouse enter/leave signals to the popup widgets children.
  for _, option in ipairs(options_container:get_children()) do
    option:connect_signal("mouse::enter", function()
      popup_widget:_select("hover", { hovered_id = option.id })
    end)
    -- Pretty sure this is not the best way to do this, but it works;
    -- the correct way should use the 'mouse::press' signal.
    option:buttons(
      gears.table.join(
        awful.button({}, 1, function()
          popup_widget:_exec_current()
        end)
      )
    )

  end

  return popup_widget
end

return M
