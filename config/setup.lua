pcall(require, "luarocks.loader")
require("awful.autofocus")

local naughty = require("naughty")
local awful = require("awful")

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

awful.layout.layouts = {
  awful.layout.suit.spiral,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.fair,
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  awful.layout.suit.max
}

awful.mouse.snap.edge_enabled = false
