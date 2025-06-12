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
        homepageUrl = "";
      };
      utils.enable = true;
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
  };
  monitors = [
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      scale = 1.0;
      x = 0;
      y = 0;
      workspace = "2";
    }
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refreshRate = 60.0;
      scale = 1.0;
      x = 0;
      y = 1080;
      workspace = "1";
      primary = true;
    }
  ];
}
