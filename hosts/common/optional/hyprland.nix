{
  inputs,
  pkgs,
  ...
}:
{
  programs.hyprland = {
    xwayland.enable = true;
    enable = true;
  };

  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };

  environment.systemPackages = [
    inputs.hyprland-qtutils.packages.${pkgs.system}.default
    pkgs.xdg-utils # xdg-open
    pkgs.qt5.qtwayland
    pkgs.qt6.qtwayland
  ];
}
