{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/louis
    ../optional/gnome.nix
  ];
  services = {
    xserver = {
      enable = true;
      layout = "fr";
       desktopManager.gnome = {
         enable = true;
      };
      displayManager.gdm = {
        enable = true;
      };
    };
  };

  networking.hostName = "hircine";

  # XDG Portals
  programs.hyprland = {
    enable = true;
  };

  # XDG Portals
  xdg = {
    portal = {
      enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.xdg-utils # xdg-open
  ];

  # environment.sessionVariables = {
  #   # NIXOS_OZONE_WL = "1"; disable for now since vs code is broken
  #   SDL_VIDEODRIVER = "wayland";
  #   _JAVA_AWT_WM_NONREPARENTING = "1";
  #   CLUTTER_BACKEND = "wayland";
  #   WLR_RENDERER = "vulkan";
  #   QT_QPA_PLATFORM = "wayland";
  # };
}
