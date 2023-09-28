{pkgs, ...}: {
  home.packages = with pkgs; [
    neofetch
    eza
    bat
    trash-cli
    du-dust
    git-open
    screen
    tmux
    noti
    tokei
  ];
}
