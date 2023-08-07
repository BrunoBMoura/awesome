beautiful.init(gears.filesystem.get_configuration_dir() .. "kanagawa/theme.lua")

myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", USER.terminal .. " -e man awesome" },
   { "edit config", USER.editor .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

vicious = require("vicious")

menubar = require("menubar")

menubar.utils.terminal = USER.terminal

mymainmenu = awful.menu({
  items = {
    { "awesome", myawesomemenu, beautiful.awesome_icon },
    { "open terminal", USER.terminal }
  }
})

local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ USER.keys.super }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ USER.keys.super }, 3, function(t)
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

function set_wallpaper(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

screen.connect_signal("property::geometry", set_wallpaper)

volume_widget = require('awesome-wm-widgets.volume-widget.volume')

wibox = require("wibox")

keyboard_layout = awful.widget.keyboardlayout()

mytextclock = wibox.widget.textclock()

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)
  awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])
  s.mypromptbox = awful.widget.prompt()
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

awful.mouse.snap.edge_enabled = false
