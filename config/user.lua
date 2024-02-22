local portable = true
local device = portable and "/dev/nvme0n1p3" or "/dev/sda2"

local palettes = require("config.palettes")

USER = {
  portable = portable,
  terminal = "kitty",
  editor = os.getenv("EDITOR") or "nvim",
  device = device,
  keys = {
    alt   = "Mod1",
    super = "Mod4",
    shift = "Shift",
    ctrl  = "Control"
  },
  palette = palettes.kanagawa,
  font = function(size)
    local default_size = 12
    return string.format("JetBrains Mono %d", size or default_size)
  end
}
