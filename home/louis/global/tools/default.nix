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
    ./helix
    ./oh-my-zsh.nix
    ./mime.nix
  ];
}
