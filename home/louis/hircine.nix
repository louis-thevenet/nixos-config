{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./home-manager.nix
    ./dev
    ./global
    ./gui
    ./cli
    ./optional/gnome.nix
  ];
}
