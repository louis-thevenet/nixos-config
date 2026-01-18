{
  pkgs,
  inputs,
  ...
}:
let
  xwayland-satellite-package = pkgs.unstable.xwayland-satellite;
in
{
  imports = [
    inputs.niri.nixosModules.niri
  ];
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdgOpenUsePortal = true;
    };
  };
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  programs.xwayland = {
    enable = true;
    package = xwayland-satellite-package;
  };
  environment.systemPackages = [ xwayland-satellite-package ]; # Needed in $PATH
  services.xserver.exportConfiguration = true;
  environment.sessionVariables = {

    DISPLAY = ":0";
    NIXOS_OZONE_WL = "1";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";
  };
}
