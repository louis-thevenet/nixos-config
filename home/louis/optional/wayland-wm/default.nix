{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./mako.nix
    ./waybar.nix
    ./swayidle.nix
    ./swaylock.nix
    ./wofi.nix
    ./copyq.nix
  ];
  home.packages = with pkgs; [
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
    swww
  ];
}
