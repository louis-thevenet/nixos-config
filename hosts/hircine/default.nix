{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/louis
    ../optional/gnome.nix
  ];
  networking.hostName = "hircine";

  services = {
    xserver = {
      enable = true;
      xkb.layout = "fr";
      # desktopManager.gnome = {
      #   enable = true;
      # };
      displayManager.gdm = {
        enable = true;
      };
    };
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth

  programs.hyprland = {
    enable = true;
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];
  # Tell Xorg to use the nvidia driver
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is needed for most wayland compositors
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # XDG Portals
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        xdg-desktop-portal-hyprland
      ];
    };
  };
}
