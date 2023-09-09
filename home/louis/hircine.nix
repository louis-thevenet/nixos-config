{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./global
    ./gui
    ./cli
    ./dev
    ./optional/gnome.nix
  ];
}
