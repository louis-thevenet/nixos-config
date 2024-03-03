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
    todoist
    tokei
    ollama
    linuxKernel.packages.linux_6_1.perf
    nm-tray
    killall
    calcurse
    wget
  ];
}
