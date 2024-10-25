{pkgs, ...}: {
  imports = [
    ./global
    ./features
  ];

  home-config = {
    cli = {
      commonTools.enable = true;
      VPNC.enable = false;
      nvTop.enable = false;
    };
    gui = {
      kitty.enable = true;
      schizofox = {
        enable = true;
        searxngInstance = "http://192.168.1.53:8080";
      };
      social.enable = true;
      utils.enable = true;
      ai.lmstudio.enable = true;
    };
    dev = {
      vscode.enable = true;
      devTools.enable = true;
      jetbrains.enable = true;
    };
    desktop.hyprland = {
      enable = true;
      nvidia = true;
      hypridleConfig = {
        screenDimTime = 300;
        lockTime = 400;
        suspendTime = 99999; # currently broken on magnus
      };
    };
    desktop.stylix.enable = true;
    misc = {
      nextcloud.enable = true;
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
      name = "DP-3";
      width = 2560;
      height = 1440;
      x = 1920;
      workspace = "1";
      primary = true;
    }
    # get rid of the ghost monitor
    {
      name = "Unknown-1";
      enabled = false;
    }
  ];
}
