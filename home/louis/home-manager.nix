{
  config,
  nix-colors,
  ...
}: {
  imports = [
    ./options
    nix-colors.homeManagerModules.default
  ];

  colorScheme = nix-colors.colorSchemes.dracula;

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
