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
    ./nixvim
    ./oh-my-zsh.nix
    ./mime.nix
  ];
}
