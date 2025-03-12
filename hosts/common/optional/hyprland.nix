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
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
  environment.systemPackages = [
    inputs.hyprland-qtutils.packages.${pkgs.system}.default
  ];
}
