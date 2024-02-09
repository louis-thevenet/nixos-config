{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./home-manager.nix
    ./global
    ./gui
    ./cli
    ./optional/hyprland
    ./optional/wayland-wm
    ./gaming
  ];
  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      x = 0;
      workspace = "1";
      primary = true;
    }
  ];

  fontProfiles = {
    enable = true;
    monospace = {
      family = "FiraCode Nerd Font";
      package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };
}
