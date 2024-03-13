{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./global
    ./features
  ];

  home-config = {
    cli = {
      CommonTools.enable = true;
      VPNC.enable = true;
    };
    gui = {
      Kitty.enable = true;
      Schizofox.enable = true;
      Social.enable = true;
      Utils.enable = true;
    };
    dev = {
      VsCode.enable = true;
      DevTools.enable = true;
    };
    desktop.Hyprland.enable = true;
    virtualization.Virtualization.enable = true;
  };

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
