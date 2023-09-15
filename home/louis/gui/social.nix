{pkgs, ...}: {
  home.packages = with pkgs; [
    whatsapp-for-linux
    spotify
    discord
    betterdiscordctl
  ];
}
