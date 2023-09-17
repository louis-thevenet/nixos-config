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
}
