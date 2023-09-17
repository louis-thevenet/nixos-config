{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./config.nix

    ./direnv.nix
    ./git.nix
    ./neovim.nix
    ./oh-my-zsh.nix
  ];
}
