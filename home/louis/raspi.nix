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

  home.packages = with pkgs; [
    matrix-synapse
  ];
}
