{ config, ... }:
let
  cfg = config.home-config.desktop;
in
{
  services.hyprpaper.enable = cfg.wayland.hyprland.enable;
}
