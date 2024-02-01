{
  config,
  pkgs,
  nix-colors,
  ...
}: {
  imports = [
    ./options
    nix-colors.homeManagerModules.default
  ];

  colorScheme = nix-colors.colorSchemes.solarized-light;

  scheduler = {
    enable = true;
    name = "test_scheduler";
    filePath = "${config.home.homeDirectory}/test_scheduler";
    versions = [
      {
        content = "blablabla";
        start = "test";
      }
    ];
  };

  home = {
    username = "louis";
    homeDirectory = "/home/louis";
  };

  gtk = {
    enable = true;

    theme = {
      name = "marwaita-pop_os";
      package = pkgs.marwaita-pop_os;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.sessionVariables.GTK_THEME = "marwaita-pop_os";
  home.sessionVariables.TERMINAL = "kitty";
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
