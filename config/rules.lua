local beautiful = require("beautiful")
local awful = require("awful")

awful.rules.rules = {
    -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus        = awful.client.focus.filter,
      raise        = true,
      keys         = CLIENT_KEYS,
      buttons      = CLIENT_BUTTONS,
      screen       = awful.screen.preferred,
      placement    = awful.placement.no_overlap + awful.placement.no_offscreen
   }
  },
  -- Floating clients.
  {
    rule_any = {
      instance = {},
      class = { --[["Arandr"]] },
      name = {},
      role = {}
    },
    properties = { floating = false }
  },

  -- Add titlebars to normal clients and dialogs
  {
    rule_any = {
      type = { "normal", "dialog" }
    },
    properties = {
      titlebars_enabled = false
    }
  }
}
