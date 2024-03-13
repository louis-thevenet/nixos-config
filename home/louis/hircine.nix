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
      enableCommonTools = true;
      enableVPNC = true;
    };
    gui = {
      enableKitty = true;
      enableSchizofox = true;
      enableSocial = true;
      enableUtils = true;
    };
    dev = {
      enableVsCode = true;
      enableDevTools = true;
    };
    desktop.enableHyprland = true;
    virtualization.enableVirtualization = true;
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
