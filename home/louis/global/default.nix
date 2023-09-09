{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./direnv.nix
    ./git.nix
    ./neovim.nix
    ./oh-my-zsh.nix
  ];

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
  home.stateVersion = "23.05";
}
