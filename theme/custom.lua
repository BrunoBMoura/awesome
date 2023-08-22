-- There are other variable sets
-- overriding the theme.palette one when
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
--
-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gfs = require("gears.filesystem")
local dpi = xresources.apply_dpi
local themes_path = gfs.get_configuration_dir()

local theme = { palette = USER.palette }

local display = USER.palette.cyan

theme.font          = USER.font()
theme.bg_normal     = theme.palette.background
theme.bg_focus      = theme.palette.black
theme.bg_urgent     = theme.palette.yellow
theme.bg_minimize   = theme.palette.orange
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = display
theme.fg_focus      = display
theme.fg_urgent     = theme.palette.red
theme.fg_minimize   = theme.palette.black

theme.useless_gap   = dpi(1)
theme.border_width  = dpi(2)
theme.border_normal = theme.palette.black
theme.border_focus  = theme.palette.grey
theme.border_marked = theme.palette.yellow

theme.taglist_bg_focus     = display
theme.taglist_fg_focus     = theme.palette.white
theme.tasklist_fg_focus    = theme.palette.red
theme.tasklist_bg_focus    = display
theme.hotkeys_border_color = display

local taglist_square_size = dpi(6)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
  taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
  taglist_square_size, theme.fg_normal
)

theme.menu_submenu_icon = themes_path .. "theme.palette/submenu.png"
theme.menu_height       = dpi(15)
theme.menu_width        = dpi(100)
theme.wallpaper         = themes_path .. "theme/pyramid.png"

theme.layout_fairh      = themes_path .. "theme/layouts/fairhw.png"
theme.layout_fairv      = themes_path .. "theme/layouts/fairvw.png"
theme.layout_floating   = themes_path .. "theme/layouts/floatingw.png"
theme.layout_magnifier  = themes_path .. "theme/layouts/magnifierw.png"
theme.layout_max        = themes_path .. "theme/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "theme/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "theme/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path .. "theme/layouts/tileleftw.png"
theme.layout_tile       = themes_path .. "theme/layouts/tilew.png"
theme.layout_tiletop    = themes_path .. "theme/layouts/tiletopw.png"
theme.layout_spiral     = themes_path .. "theme/layouts/spiralw.png"
theme.layout_dwindle    = themes_path .. "theme/layouts/dwindlew.png"
theme.layout_cornernw   = themes_path .. "theme/layouts/cornernww.png"
theme.layout_cornerne   = themes_path .. "theme/layouts/cornernew.png"
theme.layout_cornersw   = themes_path .. "theme/layouts/cornersww.png"
theme.layout_cornerse   = themes_path .. "theme/layouts/cornersew.png"

theme.awesome_icon = theme_assets.awesome_icon(
  theme.menu_height, theme.bg_focus, theme.fg_focus
)

theme.icon_theme = nil

return theme
