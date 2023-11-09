-- Custom user settings
local palettes = {
  kanagawa = {
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
  },
}

local portable = true
local device = portable and "/dev/nvme0n1p3" or "/dev/sda2"

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
