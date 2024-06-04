{ pkgs, ... }: {
  imports = [
    ./global
    ./features
  ];

  home-config = {
    cli = {
      commonTools.enable = true;
      VPNC.enable = true;
      nvTop.enable = true;
    };
    gui = {
      kitty.enable = true;
      schizofox = {
        enable = true;
        searxngInstance = "http://192.168.1.53:8080";
      };
      social.enable = true;
      utils.enable = true;
      lmstudio.enable = true;
    };
    dev = {
      vscode.enable = true;
      devTools.enable = true;
      jetbrains.enable = true;
    };
    desktop.hyprland = {
      enable = true;
      hypridleConfig = {
        screenDimTime = 300;
        lockTime = 400;
        suspendTime = 99999; # currently broken on magnus
      };
    };
    virtualization.enable = true;
    gaming.enable = true;
  };

  monitors = [
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      x = 0;
      workspace = "2";
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
      package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };
}
