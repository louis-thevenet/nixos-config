{pkgs, ...}: {
  imports = [
    ./global
    ./features
  ];

  home-config = {
    cli = {
      commonTools.enable = true;
    };
    gui = {
      kitty.enable = true;
      schizofox.enable = true;
      social.enable = true;
      utils.enable = true;
      ai.comfyUI.enable = true;
      ai.lmstudio.enable = true;
    };
    dev = {
      vscode.enable = true;
      devTools.enable = true;
    };
    desktop.hyprland = {
      enable = true;
      waybarConfig.batteryName = "BAT1";
    };
    desktop.stylix.enable = true;
    misc.nextcloud.enable = true;
  };
  monitors = [
    {
      name = "eDP-1";
      width = 2880;
      height = 1620;
      refreshRate = 120;
      scale = 1.5;
      x = 0;
      workspace = "1";
      primary = true;
    }
  ];
}
