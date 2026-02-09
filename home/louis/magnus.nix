{ ... }:
{
  imports = [
    ./global
    ./features
  ];

  home-config = {
    cli.commonTools.enable = true;
    gui = {
      kitty.enable = true;
      firefox = {
        enable = true;
        searxngInstance = {
          local = true;
          url = "http://127.0.0.1";
          port = 30070;
        };
        homepageUrl = "db.ltvnt.com";
      };
      social = {
        enable = true;
        noise_reduction.enable = true;
      };
      utils.enable = true;
    };
    dev = {
      vscode.enable = true;
      devTools.enable = true;
      helixAdvancedConfig.enable = true;
    };
    desktop = {
      stylix.enable = true;
      wayland = {
        enable = true;
        niri = {
          enable = true;
          brokenAudioMuteKey = true;
        };
      };
    };
    misc.nextcloud.enable = true;

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
    # # get rid of the ghost monitor
    # {
    #   name = "Unknown-1";
    #   enabled = false;
    # }
  ];
}
