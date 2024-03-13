{pkgs, ...}: {
  home.packages = with pkgs; [
    screen
    tmux
    tokei
  ];
}
