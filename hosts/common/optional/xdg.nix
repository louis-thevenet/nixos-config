{ pkgs, ... }:
{
  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
    };
  };
  environment.systemPackages = [
    pkgs.xdg-utils # xdg-open
    pkgs.qt5.qtwayland
    pkgs.qt6.qtwayland
  ];
}
