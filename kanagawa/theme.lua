---------------------------
-- kanagawa awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_configuration_dir()

local kanagawa = {
    black      = "#16161d",
    background = "#181616",
    red        = "#c4746e",
    green      = "#87a987",
    yellow     = "#c4b28a",
    blue       = "#8ba4b0",
    magenta    = "#a292a3",
    cyan       = "#8ea4a2",
    white      = "#c5c9c5",
    grey       = "#282727",
    orange     = "#b6927b",
    border     = "#2d4f67"
}

local theme = {}

local display = kanagawa.border
theme.palette = kanagawa

theme.font          = "JetBrains Mono 12"
theme.bg_normal     = kanagawa.background
theme.bg_focus      = kanagawa.black
theme.bg_urgent     = kanagawa.yellow
theme.bg_minimize   = kanagawa.orange
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = kanagawa.white
theme.fg_focus      = kanagawa.orange
theme.fg_urgent     = kanagawa.red
theme.fg_minimize   = kanagawa.black

theme.useless_gap   = dpi(2)
theme.border_width  = dpi(1)
theme.border_normal = kanagawa.black
theme.border_focus  = display
theme.border_marked = kanagawa.yellow

-- There are other variable sets
-- overriding the kanagawa one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"
theme.taglist_bg_focus = display
theme.taglist_fg_focus = kanagawa.white
theme.tasklist_fg_focus = kanagawa.red
theme.tasklist_bg_focus = display
theme.hotkeys_border_color = display

-- Generate taglist squares:
-- local taglist_square_size = dpi(4)
local taglist_square_size = dpi(6)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."kanagawa/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.wallpaper = themes_path.."kanagawa/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."kanagawa/layouts/fairhw.png"
theme.layout_fairv = themes_path.."kanagawa/layouts/fairvw.png"
theme.layout_floating  = themes_path.."kanagawa/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."kanagawa/layouts/magnifierw.png"
theme.layout_max = themes_path.."kanagawa/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."kanagawa/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."kanagawa/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."kanagawa/layouts/tileleftw.png"
theme.layout_tile = themes_path.."kanagawa/layouts/tilew.png"
theme.layout_tiletop = themes_path.."kanagawa/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."kanagawa/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."kanagawa/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."kanagawa/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."kanagawa/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."kanagawa/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."kanagawa/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
