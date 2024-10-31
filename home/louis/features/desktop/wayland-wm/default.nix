{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
in {
  imports = [
    ./swaync.nix
    ./waybar.nix
    ./rofi.nix
    ./cliphist.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./battery.nix
  ];
  home.packages = mkIf cfg.hyprland.enable (
    with pkgs; [
      meson
      wayland-protocols
      wayland-utils
      wlroots
      copyq
      wl-clipboard
    ]
  );

  services.playerctld.enable = cfg.hyprland.enable;
}
