{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./home-manager.nix

    ./global
    ./gui
    ./cli
    ./optional/gnome.nix
  ];
}
