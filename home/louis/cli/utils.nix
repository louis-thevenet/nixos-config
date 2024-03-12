{pkgs, ...}: {
  home.packages = with pkgs; [
    neofetch
    eza
    bat
    trash-cli
    du-dust
    git-open
    magic-wormhole
    screen
    tmux
    noti
    tokei
    nm-tray
    killall
    wget
    nvtop
  ];
}
