{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
in
{
  imports = [
    ./swaync.nix
    ./waybar.nix
    ./rofi.nix
    ./cliphist.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./battery.nix
    ./albert
    ./niri
  ];
  home.packages = mkIf cfg.wayland.enable (
    with pkgs;
    [
      meson
      wayland-protocols
      wayland-utils
      wlroots
      copyq
      wl-clipboard
    ]
  );

  services.playerctld.enable = cfg.wayland.enable;
  home.sessionVariables = {
    DISPLAY = ":0";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    CLUTTER_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";
    XDG_SESSION_DESKTOP = "Niri";
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "niri";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    NIXOS_OZONE_WL = "1";
    SDL_VIDEODRIVER = "wayland";
    XCOMPOSEFILE = "${config.xdg.configHome}/xcompose";
  };
  xdg.portal = {
    enable = true;
    config.common.default = [
      "gtk"
      "gnome"
    ];
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
