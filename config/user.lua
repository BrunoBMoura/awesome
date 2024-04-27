local portable = true
local device = portable and "/dev/nvme0n1p3" or "/dev/sda2"

local palettes = require("config.appearance.palettes")

USER = {
  portable = portable,
  terminal = "wezterm",
  editor = os.getenv("EDITOR") or "nvim",
  device = device,
  keys = {
    alt   = "Mod1",
    super = "Mod4",
    shift = "Shift",
    ctrl  = "Control"
  },
  palette = palettes.plastlins,
  font = function(size)
    local default_size = 12
    return string.format("JetBrainsMono %d", size or default_size)
  end
}
