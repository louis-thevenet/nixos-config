{pkgs, ...}: {
  imports = [
    ./global
    ./features
    ./features/impermanence.nix
  ];

  home-config = {
    cli = {
      commonTools.enable = true;
      VPNC.enable = false;
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
    desktop.hyprland.enable = false;
    desktop.stylix.enable = false;
    virtualization.enable = false;
    misc.nextcloud.enable = false;
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
