{
  config,
  nix-colors,
  ...
}: {
  imports = [
    ./options
    nix-colors.homeManagerModules.default
  ];

  colorScheme = nix-colors.colorSchemes.solarized-light;

  home = {
    username = "louis";
    homeDirectory = "/home/louis";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
