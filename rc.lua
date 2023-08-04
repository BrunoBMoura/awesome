
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")

local awful = require("awful")

require("awful.autofocus")

local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

local volume_widget = require('awesome-wm-widgets.volume-widget.volume')

local configs = {
  terminal = "kitty",
  editor = os.getenv("EDITOR") or "vim",
  keys = {
    alt = "Mod1",
    super = "Mod4",
    shift = "Shift",
    ctrl = "Control"
  }
}

if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
    })

    in_error = false
  end)
end

beautiful.init(gears.filesystem.get_configuration_dir() .. "kanagawa/theme.lua")

beautiful.useless_gap = 2
awful.mouse.snap.edge_enabled = false

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.fair,
--[[
awful.layout.suit.tile.left,
awful.layout.suit.max,
    awful.layout.suit.magnifier,
    awful.layout.suit.spiral,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.corner.nw, ]]
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

local myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", configs.terminal .. " -e man awesome" },
   -- { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local mymainmenu = awful.menu({
  items = {
    { "awesome", myawesomemenu, beautiful.awesome_icon },
    { "open terminal", configs.terminal }
  }
})

-- Menubar configuration
menubar.utils.terminal = configs.terminal

-- Keyboard map indicator and switcher
local keyboard_layout = awful.widget.keyboardlayout()

local mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ configs.keys.super }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ configs.keys.super }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal(
        "request::activate",
        "tasklist",
        {raise = true}
      )
    end
  end),
  awful.button({ }, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({ }, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function()
    awful.client.focus.byidx(-1)
  end)
)

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Each screen has its own tag table.
  -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
  awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(
    gears.table.join(
      awful.button({ }, 1, function() awful.layout.inc( 1) end),
      awful.button({ }, 3, function() awful.layout.inc(-1) end),
      awful.button({ }, 4, function() awful.layout.inc( 1) end),
      awful.button({ }, 5, function() awful.layout.inc(-1) end)
    )
  )
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  s.mytasklist = awful.widget.tasklist {
    screen   = s,
    filter   = awful.widget.tasklist.filter.currenttags,
    buttons  = tasklist_buttons,
    layout   = {
      spacing_widget = {
        {
          forced_width  = 5,
          forced_height = 25,
          thickness     = 1,
          color         = '#181616',
          widget        = wibox.widget.separator
        },
        valign = 'center',
        halign = 'center',
        widget = wibox.container.place,
      },
      spacing = 5,
      layout  = wibox.layout.fixed.horizontal
    },
    widget_template = {
      {
        wibox.widget.base.make_widget(),
        forced_height = 5,
        id            = 'background_role',
        widget        = wibox.container.background,
      },
      {
        {
          id     = 'clienticon',
          widget = awful.widget.clienticon,
        },
        margins = 5,
        widget  = wibox.container.margin
      },
      nil,
      create_callback = function(self, c, index, objects)
        self:get_children_by_id('clienticon')[1].client = c
      end,
      layout = wibox.layout.align.vertical,
    },
  }
  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s })
  -- Add widgets to the wibox
  s.mywibox:setup( {
    layout = wibox.layout.align.horizontal,
    expand = "none",
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.mytaglist,
      s.mypromptbox,
      s.mytasklist
    },
    { -- Middle widgets
      layout = wibox.layout.fixed.horizontal,
      mytextclock
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      volume_widget({ widget_type = "horizontal_bar" }),
      keyboard_layout,
      wibox.widget.systray(),
      s.mylayoutbox
    },
  })
end)

-- {{{ Mouse bindings
root.buttons(
  gears.table.join(
    awful.button({ }, 3, function() mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
  )
)

local globalkeys = gears.table.join(
  awful.key(
    { configs.keys.super }, "]", function() volume_widget:inc(5) end,
    { description = "increases the volume", group = "custom" }
  ),
  awful.key(
    { configs.keys.super }, "[", function() volume_widget:dec(5) end,
    { description = "decreases the volume", group = "custom" }
  ),
  awful.key(
    { configs.keys.super }, "s", hotkeys_popup.show_help,
    { description = "show help", group = "awesome" }
  ),
  awful.key({ configs.keys.super }, "space", function()
      awful.spawn.with_shell("bash " ..
                             gears.filesystem.get_configuration_dir() ..
                             "scripts/kbswap_br_us.sh &>> /tmp/kb_swap.log")
    end,
    { description = "swaps keyboard layout", group = "custom"}
  ),
  awful.key({ configs.keys.super }, "p", function()
      awful.spawn.with_shell("rofi -show drun -show-icons &>> /tmp/rofi.log")
    end,
    { description = "custom launcher with rofi", group = "custom"}
  ),
  awful.key({ configs.keys.alt }, "Tab",  function()
      awful.spawn.with_shell("rofi -show windowcd -show-icons &>> /tmp/rofi.log")
    end,
    { description = "alt+tab like swapping with rofi", group = "custom"}
  ),
  awful.key(
    { configs.keys.super }, "Left",
    awful.tag.viewprev,
    { description = "view previous", group = "tag"}
  ),
  awful.key(
    { configs.keys.super }, "Right",  awful.tag.viewnext,
    { description = "view next", group = "tag"}
  ),

  awful.key(
    { configs.keys.super }, "Escape", awful.tag.history.restore,
    { description = "go back", group = "tag"}
  ),
  awful.key({ configs.keys.super }, "j", function()
        awful.client.focus.byidx( 1)
    end,
    { description = "focus next by index", group = "client"}
  ),
  awful.key({ configs.keys.super }, "k", function()
      awful.client.focus.byidx(-1)
    end,
    {description = "focus previous by index", group = "client"}
  ),
  awful.key({ configs.keys.super }, "w", function()
      mymainmenu:show()
    end,
    {description = "show main menu", group = "awesome"}
  ),
  awful.key({ configs.keys.super, "Shift" }, "j", function()
      awful.client.swap.global_bydirection("down")
    end,
    { description = "swap with next client by index", group = "client"}
  ),
  awful.key({ configs.keys.super, "Shift" }, "k", function()
      awful.client.swap.global_bydirection("up")
    end,
    { description = "swap with previous client by index", group = "client"}
  ),
  awful.key({ configs.keys.super, "Shift" }, "h", function()
      awful.client.swap.global_bydirection("left")
    end,
    { description = "swap with previous client by index", group = "client"}
  ),
  awful.key({ configs.keys.super, "Shift" }, "l", function()
      awful.client.swap.global_bydirection("right")
    end,
    { description = "swap with previous client by index", group = "client"}
  ),
  awful.key({ configs.keys.super, "Control" }, "j", function()
      awful.screen.focus_relative(1)
    end,
    {description = "focus the next screen", group = "screen"}
  ),
  awful.key({ configs.keys.super, "Control" }, "k", function()
    awful.screen.focus_relative(-1)
  end,
  {description = "focus the previous screen", group = "screen"}
  ),
  awful.key(
    { configs.keys.super }, "u", awful.client.urgent.jumpto,
    {description = "jump to urgent client", group = "client"}
  ),
  awful.key({ configs.keys.super }, "Tab", function()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    {description = "go back", group = "client"}
  ),
  -- Standard program
  awful.key({ configs.keys.super }, "Return", function()
      awful.spawn(configs.terminal)
    end,
    {description = "open a terminal", group = "launcher"}),
  awful.key(
    { configs.keys.super, "Control" }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}
  ),
  awful.key(
    { configs.keys.super, "Shift" }, "q", awesome.quit,
    {description = "quit awesome", group = "awesome"}
  ),
  awful.key(
    { configs.keys.super }, "l", function()
      awful.tag.incmwfact(0.05)
    end,
    {description = "increase master width factor", group = "layout"}
  ),
  awful.key(
    { configs.keys.super, }, "h", function()
      awful.tag.incmwfact(-0.05)
    end,
  {description = "decrease master width factor", group = "layout"}
  ),
  awful.key(
    { configs.keys.super, "Shift" }, "h", function()
      awful.tag.incnmaster( 1, nil, true)
    end,
    {description = "increase the number of master clients", group = "layout"}
  ),
  awful.key(
    { configs.keys.super, "Shift" }, "l", function()
        awful.tag.incnmaster(-1, nil, true)
    end,
    {description = "decrease the number of master clients", group = "layout"}
  ),
  awful.key(
    { configs.keys.super, "Control" }, "h", function()
      awful.tag.incncol(1, nil, true)
    end,
    {description = "increase the number of columns", group = "layout"}
  ),
  awful.key(
    { configs.keys.super, "Control" }, "l", function()
      awful.tag.incncol(-1, nil, true)
    end,
    {description = "decrease the number of columns", group = "layout"}
  ),
  awful.key(
    { "Control" }, "space", function()
      awful.layout.inc(1)
    end,
    {description = "select next", group = "layout"}
  ),
  awful.key(
    { configs.keys.alt, "Shift" }, "space", function()
      awful.layout.inc(-1)
    end,
    {description = "select previous", group = "layout"}
  ),
  awful.key(
    { configs.keys.super, "Control" }, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
          c:emit_signal("request::activate", "key.unminimize", { raise = true })
        end
    end,
    {description = "restore minimized", group = "client"}
  ),

  -- Prompt
  awful.key(
    { configs.keys.super }, "r", function()
      awful.screen.focused().mypromptbox:run()
    end,
    {description = "run prompt", group = "launcher"}
  ),

  awful.key(
    { configs.keys.super }, "x", function()
      awful.prompt.run {
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
      }
    end,
    {description = "lua execute prompt", group = "awesome"}
  ),
  -- Menubar
  awful.key(
    { configs.keys.super, "Shift" }, "p", function()
      menubar.show()
    end,
    {description = "show the menubar", group = "launcher"}
  )
)

clientkeys = gears.table.join(
  awful.key({ configs.keys.super, }, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}
  ),
  awful.key({ configs.keys.super, "Shift" }, "c", function(c)
      c:kill()
    end,
    {description = "close", group = "client"}
  ),
  awful.key({ configs.keys.super, "Control" }, "space",  awful.client.floating.toggle,
    {description = "toggle floating", group = "client"}
  ),
  awful.key({ configs.keys.super, "Control" }, "Return", function(c)
      c:swap(awful.client.getmaster())
    end,
    {description = "move to master", group = "client"}
  ),
  awful.key({ configs.keys.super, }, "o", function(c)
      c:move_to_screen()
    end,
    {description = "move to screen", group = "client"}
  ),
  awful.key({ configs.keys.super, }, "t", function(c)
      c.ontop = not c.ontop
    end,
    {description = "toggle keep on top", group = "client"}
  ),
  awful.key({ configs.keys.super, }, "n", function(c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end ,
    {description = "minimize", group = "client"}
  ),
  awful.key({ configs.keys.super, }, "m", function(c)
      c.maximized = not c.maximized
      c:raise()
    end ,
    {description = "(un)maximize", group = "client"}
  ),
  awful.key(
    { configs.keys.super, "Control" }, "m", function(c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end,
    {description = "(un)maximize vertically", group = "client"}
  ),
  awful.key({ configs.keys.super, "Shift" }, "m", function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end,
    {description = "(un)maximize horizontally", group = "client"}
  )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ configs.keys.super }, "#" .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      {description = "view tag #" .. i, group = "tag"}
    ),
    -- Toggle tag display.
    awful.key({ configs.keys.super, "Control" }, "#" .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      {description = "toggle tag #" .. i, group = "tag"}
    ),
    -- Move client to tag.
    awful.key({ configs.keys.super, "Shift" }, "#" .. i + 9, function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      {description = "move focused client to tag #"..i, group = "tag"}
    ),
    -- Toggle tag on focused client.
    awful.key({ configs.keys.super, "Control", "Shift" }, "#" .. i + 9, function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      {description = "toggle focused client on tag #" .. i, group = "tag"}
    )
  )
end

clientbuttons = gears.table.join(
  awful.button({ }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
  end),
  awful.button({ configs.keys.super }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    awful.mouse.client.move(c)
  end),
  awful.button({ configs.keys.super }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    awful.mouse.client.resize(c)
  end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
      rule = { },
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus        = awful.client.focus.filter,
        raise        = true,
        keys         = clientkeys,
        buttons      = clientbuttons,
        screen       = awful.screen.preferred,
        placement    = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },
    -- Floating clients.
    {
      rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    {
      rule_any = {
        type = { "normal", "dialog" }
      },
      properties = {
        titlebars_enabled = false
      }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end
  if awesome.startup
  and not c.size_hints.user_position
  and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({ }, 1, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c):setup {
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal
    },
    { -- Middle
      { -- Title
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal
    },
    { -- Right
      awful.titlebar.widget.floatingbutton (c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton   (c),
      awful.titlebar.widget.ontopbutton    (c),
      awful.titlebar.widget.closebutton    (c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)

awful.spawn.with_shell("picom")
awful.spawn.with_shell("systemctl start logid.service")

