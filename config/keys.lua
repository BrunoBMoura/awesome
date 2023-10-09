local groups = {
  custom   = "custom",
  widget   = "widget",
  awesome  = "awesome",
  client   = "client",
  launcher = "launcher",
  layout   = "layout"
}

-- Easier readability for keybind definition.
local function keybind(mods, keys, description, group, impl)
  return awful.key(mods, keys, impl, { description = description, group = group })
end

local keys = gears.table.join(
  -- Custom keybinds
  keybind({ USER.keys.alt }, "k", "focus the upper screen", groups.custom, function()
    awful.screen.focus_bydirection("up")
  end),
  keybind({ USER.keys.alt }, "j", "focus the lower screen", groups.custom, function()
      awful.screen.focus_bydirection("down")
  end),
  keybind({ USER.keys.alt }, "h", "focus the left screen", groups.custom, function()
      awful.screen.focus_bydirection("left")
  end),
  keybind({ USER.keys.alt }, "l", "focus the right screen", groups.custom, function()
      awful.screen.focus_bydirection("right")
  end),
  keybind({ USER.keys.super }, "p", "custom launcher with rofi", groups.custom, function()
      awful.spawn.with_shell("rofi -show drun -show-icons &>> /tmp/rofi.log")
  end),
  keybind({ USER.keys.alt }, "Tab", "alt+tab like swapping with rofi", groups.custom, function()
      awful.spawn.with_shell("rofi -show windowcd -show-icons &>> /tmp/rofi.log")
  end),
  keybind({ USER.keys.super }, "j", "move focus down", groups.custom, function()
    awful.client.focus.bydirection("down")
  end),
  keybind({ USER.keys.super }, "k", "move focus up", groups.custom, function()
    awful.client.focus.bydirection("up")
  end),
  keybind({ USER.keys.super }, "l", "move focus right", groups.custom, function()
    awful.client.focus.bydirection("right")
  end),
  keybind({ USER.keys.super }, "h", "move focus left", groups.custom, function()
    awful.client.focus.bydirection("left")
  end),
  keybind({ USER.keys.super, USER.keys.alt }, "l", "increases master width factor", groups.custom, function()
    awful.tag.incmwfact(0.05)
  end),
  keybind({ USER.keys.super, USER.keys.alt }, "h", "decreases master width factor", groups.custom, function()
    awful.tag.incmwfact(-0.05)
  end),
  keybind({ USER.keys.super, USER.keys.shift }, "j", "swap with lower client by direction", groups.custom, function()
    awful.client.swap.global_bydirection("down")
  end),
  keybind({ USER.keys.super, USER.keys.shift }, "k", "swap with upper client by direction", groups.custom, function()
    awful.client.swap.global_bydirection("up")
  end),
  keybind({ USER.keys.super, USER.keys.shift }, "h", "swap with left client by direction", groups.custom, function()
    awful.client.swap.global_bydirection("left")
  end),
  keybind({ USER.keys.super, USER.keys.shift }, "l", "swap with right client by direction", groups.custom, function()
    awful.client.swap.global_bydirection("right")
  end),

  -- Widgets keybinds
  keybind({ USER.keys.super }, "]", "increases the volume", groups.widget, function()
    awesome.emit_signal("increase::volume")
  end),
  keybind({ USER.keys.super }, "[", "decreases the volume", groups.widget, function()
    awesome.emit_signal("decrease::volume")
  end),
  keybind({ USER.keys.super }, "space", "swaps the keyboard layout", groups.widget, function()
    awesome.emit_signal("switch::keyboard_layout")
  end),
  keybind({ USER.keys.super }, "c", "opens the control center", groups.widget, function()
    awesome.emit_signal("toggle::control_center")
  end),

  -- Awesome keybinds
  keybind({ USER.keys.super }, "s", "show help", groups.awesome, require("awful.hotkeys_popup").show_help),
  keybind({ USER.keys.super }, "w", "show main menu", groups.awesome, function()
    main_menu:show()
  end),
  keybind({ USER.keys.super, USER.keys.ctrl }, "r", "reloads awesome", groups.awesome, awesome.restart),
  keybind({ USER.keys.super, USER.keys.shift, USER.keys.alt }, "q", "quits awesome", groups.awesome, awesome.quit),

  -- Client keybinds
  keybind({ USER.keys.super }, "u", "jump to urgent client", groups.client, awful.client.urgent.jumpto),
  keybind({ USER.keys.super }, "Tab", "go back", groups.client, function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end),
  keybind({ USER.keys.super, USER.keys.ctrl }, "n", "restores minimzed window", groups.client, function()
    -- Focus restored client
    local c = awful.client.restore()
    if c then
      c:emit_signal("request::activate", "key.unminimize", { raise = true })
    end
  end),

  -- Layout keybinds
  keybind({ USER.keys.ctrl }, "space", "selects next layout", groups.layout, function()
    awful.layout.inc(1)
  end),
  keybind({ USER.keys.super }, "Return", "opens a terminal", groups.launcher, function()
    awful.spawn(USER.terminal)
  end),
  keybind({ USER.keys.super }, "r", "runs default prompt", groups.launcher, function()
    awful.screen.focused().mypromptbox:run()
  end),
  keybind({ USER.keys.super, USER.keys.shift }, "p", "shows the menubar", groups.launcher, function()
      menubar.show()
  end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for tag_idx = 1, 9 do
  keys = gears.table.join(keys,
    -- View tag only.
    keybind(
      { USER.keys.super }, "#" .. tag_idx + 9,
      "view tag #" .. tag_idx, groups.tag,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[tag_idx]
        if tag then
          tag:view_only()
        end
      end
    ),
    keybind(
      { USER.keys.super, USER.keys.ctrl }, "#" .. tag_idx + 9,
      "toogle tag #" .. tag_idx, groups.tag,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[tag_idx]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end
    ),
    keybind(
      { USER.keys.super, USER.keys.shift }, "#" .. tag_idx + 9,
      "move focused client to tag #" .. tag_idx, groups.tag,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[tag_idx]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end
    ),
    keybind(
      { USER.keys.super, USER.keys.ctrl, USER.keys.shift }, "#" .. tag_idx + 9,
      "toggle focused client on tag #" .. tag_idx, groups.tag,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[tag_idx]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end
    )
  )
end

root.keys(keys)

root.buttons(
  gears.table.join(
    awful.button({ }, 3, function() main_menu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
  )
)

client_keys = gears.table.join(
  keybind({ USER.keys.super }, "f", "toggle fullscreen", groups.client, function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end),
  keybind({ USER.keys.super }, "q", "close client", groups.client, function(c)
    c:kill()
  end),
  keybind({ USER.keys.super, USER.keys.ctrl }, "space", "toggle floating", groups.client, awful.client.floating.toggle),
  keybind({ USER.keys.super, USER.keys.ctrl }, "Return", "move to master", groups.client, function(c)
    c:swap(awful.client.getmaster())
  end),
  keybind({ USER.keys.super }, "o", "move to screen", groups.client, function(c)
    c:move_to_screen()
  end),
  keybind({ USER.keys.super }, "t", "toggle keep on top", groups.client, function(c)
    c.ontop = not c.ontop
  end),
  keybind({ USER.keys.super }, "n", "minimize", groups.client, function(c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
  end),
  keybind({ USER.keys.super }, "m", "(un)maximize", groups.client, function(c)
    c.maximized = not c.maximized
    c:raise()
  end),
  keybind({ USER.keys.super, USER.keys.ctrl }, "m", "(un)maximize vertically", groups.client, function(c)
    c.maximized_vertical = not c.maximized_vertical
    c:raise()
  end),
  keybind({ USER.keys.super, USER.keys.shift }, "m", "(un)maximize horizontally", groups.client, function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c:raise()
  end)
)

client_buttons = gears.table.join(
  awful.button({ }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ USER.keys.super }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ USER.keys.super }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)
