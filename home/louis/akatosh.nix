{ ... }:
{
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
      firefox = {
        enable = true;
        searxngInstance = {
          local = true;
          url = "http://127.0.0.1";
          port = 30070;
        };
        homepageUrl = "localhost:30069";
      };
      glance = {
        enable = true;
        host = "localhost";
        port = 30069;
      };
      social.enable = true;
      utils.enable = true;
      ai.lmstudio.enable = true;
    };
    dev = {
      vscode.enable = true;
      devTools.enable = true;
    };
    desktop = {
      stylix.enable = true;
      wayland = {
        enable = true;
        niri.enable = true;
        waybarConfig.batteryName = "BAT1";
      };
    };
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
