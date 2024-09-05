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
    #./nixvim
    ./helix.nix
    ./oh-my-zsh.nix
    ./mime.nix
    ./bash-scripts.nix
  ];
}
