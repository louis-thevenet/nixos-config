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
    ./cli/utils.nix
  ];
}
