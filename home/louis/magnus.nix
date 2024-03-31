{pkgs, ...}: {
  imports = [
    ./global
    ./features
  ];

  home-config = {
    cli = {
      commonTools.enable = true;
      VPNC.enable = true;
    };
    gui = {
      kitty.enable = true;
      schizofox.enable = true;
      social.enable = true;
      utils.enable = true;
    };
    dev = {
      vscode.enable = true;
      devTools.enable = true;
    };
    desktop.hyprland.enable = true;
    virtualization.enable = true;
    gaming.enable = true;
  };

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
