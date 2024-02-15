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
    #./gui/schizofox.nix
    ./optional/virt.nix
    ./gaming
    ./cli
    ./optional/hyprland
    ./optional/wayland-wm
  ];

  monitors = [
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      x = 0;
      workspace = "1";
    }
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      x = 1920;
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
