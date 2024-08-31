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
    desktop.hyprland = {
      enable = true;
      waybarConfig.batteryName = "BAT0";
    };
    desktop.stylix.enable = true;
    virtualization.enable = true;
    misc.nextcloud.enable = true;
  };

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refreshRate = 120;
      x = 0;
      workspace = "1";
      primary = true;
    }
  ];
}
