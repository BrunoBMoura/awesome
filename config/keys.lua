root.buttons(
  gears.table.join(
    awful.button({ }, 3, function() main_menu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
  )
)

global_keys = gears.table.join(
  -- Custom keybindings
  awful.key({ USER.keys.alt }, "k", function()
      awful.screen.focus_bydirection("up")
    end,
    { description = "focus the upper screen", group = "custom" }
  ),
  awful.key({ USER.keys.alt }, "j", function()
      awful.screen.focus_bydirection("down")
    end,
    { description = "focus the below screen", group = "custom" }
  ),
  awful.key({ USER.keys.alt }, "h", function()
      awful.screen.focus_bydirection("left")
    end,
    { description = "focus the left screen", group = "custom" }
  ),
  awful.key({ USER.keys.alt }, "l", function()
      awful.screen.focus_bydirection("right")
    end,
    { description = "focus the right screen", group = "custom" }
  ),
  awful.key({ USER.keys.super }, "]", function()
      volume_widget:increase(5)
    end,
    { description = "increases the volume", group = "custom" }
  ),
  awful.key({ USER.keys.super }, "[", function()
      volume_widget:decrease(5)
    end,
    { description = "decreases the volume", group = "custom" }
  ),
  awful.key({ USER.keys.super }, "space", function()
      keyboard_layout_widget:switch()
    end,
    { description = "swaps keyboard layout", group = "custom" }
  ),
  awful.key({ USER.keys.super }, "p", function()
      awful.spawn.with_shell("rofi -show drun -show-icons &>> /tmp/rofi.log")
    end,
    { description = "custom launcher with rofi", group = "custom" }
  ),
  awful.key({ USER.keys.alt }, "Tab",  function()
      awful.spawn.with_shell("rofi -show windowcd -show-icons &>> /tmp/rofi.log")
    end,
    { description = "alt+tab like swapping with rofi", group = "custom" }
  ),
  awful.key(
    { USER.keys.super }, "s", require("awful.hotkeys_popup").show_help,
    { description = "show help", group = "awesome" }
  ),
  awful.key(
    { USER.keys.super }, "Left",
    awful.tag.viewprev,
    { description = "view previous", group = "tag" }
  ),
  awful.key(
    { USER.keys.super }, "Right",  awful.tag.viewnext,
    { description = "view next", group = "tag" }
  ),
  awful.key(
    { USER.keys.super }, "Escape", awful.tag.history.restore,
    { description = "go back", group = "tag" }
  ),
  awful.key({ USER.keys.super }, "j", function()
        -- awful.client.focus.byidx(1)
      awful.client.focus.bydirection("down")
    end,
    { description = "move focus down", group = "custom" }
  ),
  awful.key({ USER.keys.super }, "k", function()
      awful.client.focus.bydirection("up")
    end,
    { description = "moves focus up", group = "custom" }
  ),
  awful.key({ USER.keys.super }, "l", function()
      awful.client.focus.bydirection("right")
    end,
    { description = "moves focus right", group = "custom" }
  ),
  awful.key({ USER.keys.super }, "h", function()
      -- awful.tag.incmwfact(-0.05)
      awful.client.focus.bydirection("left")
    end,
    { description = "moves focus left", group = "custom" }
  ),
  awful.key({ USER.keys.super, USER.keys.alt }, "l", function()
      awful.tag.incmwfact(0.05)
    end,
    { description = "increase master width factor", group = "custom" }
  ),
  awful.key({ USER.keys.super, USER.keys.alt }, "h", function()
      awful.tag.incmwfact(-0.05)
    end,
    { description = "decrease master width factor", group = "custom" }
  ),
  awful.key({ USER.keys.super }, "w", function()
      main_menu:show()
    end,
    { description = "show main menu", group = "awesome" }
  ),
  awful.key({ USER.keys.super, USER.keys.shift }, "j", function()
      awful.client.swap.global_bydirection("down")
    end,
    { description = "swap with down client by direction", group = "custom" }
  ),
  awful.key({ USER.keys.super, USER.keys.shift }, "k", function()
      awful.client.swap.global_bydirection("up")
    end,
    { description = "swap with up client by direction", group = "custom" }
  ),
  awful.key({ USER.keys.super, USER.keys.shift }, "h", function()
      awful.client.swap.global_bydirection("left")
    end,
    { description = "swap with left client by direction", group = "custom" }
  ),
  awful.key({ USER.keys.super, USER.keys.shift }, "l", function()
      awful.client.swap.global_bydirection("right")
    end,
    { description = "swap with right client by direction", group = "custom" }
  ),

  awful.key({ USER.keys.super, USER.keys.ctrl }, "k", function()
      awful.screen.focus_bydirection("up")
    end,
    { description = "focus the upper screen", group = "custom" }
  ),
  awful.key(
    { USER.keys.super }, "u", awful.client.urgent.jumpto,
    { description = "jump to urgent client", group = "client" }
  ),
  awful.key({ USER.keys.super }, "Tab", function()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    { description = "go back", group = "client" }
  ),
  -- Standard program
  awful.key({ USER.keys.super }, "Return", function()
      awful.spawn(USER.terminal)
    end,
    { description = "open a terminal", group = "launcher" }
  ),
  awful.key(
    { USER.keys.super, USER.keys.ctrl }, "r", awesome.restart,
    { description = "reload awesome", group = "awesome" }
  ),
  awful.key(
    { USER.keys.super, USER.keys.shift, USER.keys.alt }, "q", awesome.quit,
    { description = "quit awesome", group = "awesome" }
  ),
  awful.key({ USER.keys.super, USER.keys.shift }, "h", function()
      awful.tag.incnmaster( 1, nil, true)
    end,
    { description = "increase the number of master clients", group = "layout" }
  ),
  awful.key({ USER.keys.super, USER.keys.shift }, "l", function()
        awful.tag.incnmaster(-1, nil, true)
    end,
    { description = "decrease the number of master clients", group = "layout" }
  ),
  awful.key({ USER.keys.super, USER.keys.ctrl }, "h", function()
      awful.tag.incncol(1, nil, true)
    end,
    { description = "increase the number of columns", group = "layout" }
  ),
  awful.key({ USER.keys.super, USER.keys.ctrl }, "l", function()
      awful.tag.incncol(-1, nil, true)
    end,
    { description = "decrease the number of columns", group = "layout" }
  ),
  awful.key({ USER.keys.ctrl }, "space", function()
      awful.layout.inc(1)
    end,
    { description = "select next", group = "layout" }
  ),
  awful.key(
    { USER.keys.alt, USER.keys.shift }, "space", function()
      awful.layout.inc(-1)
    end,
    { description = "select previous", group = "layout" }
  ),
  awful.key(
    { USER.keys.super, USER.keys.ctrl }, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
          c:emit_signal("request::activate", "key.unminimize", { raise = true })
        end
    end,
    { description = "restore minimized", group = "client" }
  ),
  -- Prompt
  awful.key({ USER.keys.super }, "r", function()
      awful.screen.focused().mypromptbox:run()
    end,
    { description = "run prompt", group = "launcher" }
  ),
  awful.key({ USER.keys.super }, "x", function()
      awful.prompt.run {
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
      }
    end,
    { description = "lua execute prompt", group = "awesome" }
  ),
  awful.key({ USER.keys.super, USER.keys.shift }, "p", function()
      menubar.show()
    end,
    { description = "show the menubar", group = "launcher" }
  )
)

client_keys = gears.table.join(
  awful.key({ USER.keys.super }, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    { description = "toggle fullscreen", group = "client" }
  ),
  awful.key({ USER.keys.super }, "q", function(c)
      c:kill()
    end,
    { description = "close", group = "client" }
  ),
  awful.key(
    { USER.keys.super, USER.keys.ctrl }, "space",
    awful.client.floating.toggle,
    { description = "toggle floating", group = "client" }
  ),
  awful.key({ USER.keys.super, USER.keys.ctrl }, "Return", function(c)
      c:swap(awful.client.getmaster())
    end,
    { description = "move to master", group = "client" }
  ),
  awful.key({ USER.keys.super }, "o", function(c)
      c:move_to_screen()
    end,
    { description = "move to screen", group = "client" }
  ),
  awful.key({ USER.keys.super }, "t", function(c)
      c.ontop = not c.ontop
    end,
    { description = "toggle keep on top", group = "client" }
  ),
  awful.key({ USER.keys.super }, "n", function(c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end ,
    { description = "minimize", group = "client" }
  ),
  awful.key({ USER.keys.super }, "m", function(c)
      c.maximized = not c.maximized
      c:raise()
    end ,
    { description = "(un)maximize", group = "client" }
  ),
  awful.key({ USER.keys.super, USER.keys.ctrl }, "m", function(c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end,
    { description = "(un)maximize vertically", group = "client" }
  ),
  awful.key({ USER.keys.super, USER.keys.shift }, "m", function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end,
    { description = "(un)maximize horizontally", group = "client" }
  )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  global_keys = gears.table.join(global_keys,
    -- View tag only.
    awful.key({ USER.keys.super }, "#" .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      { description = "view tag #" .. i, group = "tag" }
    ),
    -- Toggle tag display.
    awful.key({ USER.keys.super, USER.keys.ctrl }, "#" .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      { description = "toggle tag #" .. i, group = "tag" }
    ),
    -- Move client to tag.
    awful.key({ USER.keys.super, USER.keys.shift }, "#" .. i + 9, function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      { description = "move focused client to tag #" .. i, group = "tag" }
    ),
    -- Toggle tag on focused client.
    awful.key({ USER.keys.super, USER.keys.ctrl, USER.keys.shift }, "#" .. i + 9, function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      { description = "toggle focused client on tag #" .. i, group = "tag" }
    )
  )
end

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

root.keys(global_keys)
