local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/custom.lua")

CONTROL_CENTER = require("config.widgets.control_center.init")
VOLUME_WIDGET = require("config.widgets.volume")({ icon = "󰕾 " })
KEYBOARD_LAYOUT_WIDGET = require("config.widgets.keyboard_layout")({ icon = "󰌌 " })
BATT_WIDGET = require("config.widgets.battery")({ icon = " " })

MENUBAR = require("menubar")
MENUBAR.utils.terminal = USER.terminal

local awesome_menu = {
  {
  "hotkeys", function()
    require("awful.hotkeys_popup").show_help(nil, awful.screen.focused())
  end
  },
  { "manual", USER.terminal .. " -e man awesome" },
  { "restart", awesome.restart },
  { "logout", function() awesome.quit() end }
}

MAIN_MENU = awful.menu({
  auto_expand = true,
  items = {
    { "open terminal", USER.terminal },
    { "awesome", awesome_menu, beautiful.awesome_icon }
  }
})

local function set_wallpaper(screen)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(screen)
    end
    gears.wallpaper.maximized(wallpaper, screen, true)
  end
end

local function set_screen_prefs(screen)
  if screen.index == 1 then
    set_wallpaper(screen)
    awful.tag({ "1", "2", "3", "4", "5" }, screen, awful.layout.layouts[1])
  elseif screen.index == 2 then
    awful.tag({ "1", "2", "3", "4", "5" }, screen, awful.layout.layouts[3])
  elseif screen.index == 3 then
    awful.tag({ "1", "2", "3", "4", "5" }, screen, awful.layout.layouts[3])
  end
end

local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(tag) tag:view_only() end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ USER.keys.super }, 3, function(tag)
    if client.focus then
      client.focus:toggle_tag(tag)
    end
  end)
)

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function(c) if c == client.focus then
      c.minimized = true
    else
      c:emit_signal("request::activate", "tasklist", { raise = true })
    end
  end),
  awful.button({ }, 3, function()
    awful.menu.client_list({
      theme = { width = 500 }
    })
  end)
)

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(screen)
  set_screen_prefs(screen)
  screen.mypromptbox = awful.widget.prompt()
  screen.mylayoutbox = awful.widget.layoutbox(screen)
  screen.mylayoutbox:buttons(
    gears.table.join(
      awful.button({}, 1, function() awful.layout.inc(1) end),
      awful.button({}, 3, function() awful.layout.inc(-1) end)
    )
  )
  -- Create a taglist widget
  screen.mytaglist =  require("config.taglist")(screen, taglist_buttons)
  screen.mytasklist = require("config.tasklist")(screen, tasklist_buttons)
  -- Create the wibox.
  screen.mywibox = awful.wibar({
    position = "top",
    screen = screen,
    height = dpi(35),
    -- border_width = dpi(5)
  })
  -- Add widgets to the wibox.
  screen.mywibox:setup(require("config.bar")(screen))
end)

client.connect_signal("request::titlebars", require("config.titlebar").setup_titlebar)
