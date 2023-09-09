{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    neofetch
    exa
    bat
    trash-cli
    du-dust
    git-open
    screen
    tmux
    noti
    tokei
    vpnc
  ];
}
