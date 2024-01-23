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

  networking.hostName = "magnus";
  boot.binfmt.emulatedSystems = ["aarch64-linux"]; # allows building iso for arm devices

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

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
  # Mostly from <https://www.reddit.com/r/NixOS/comments/137j18j/comment/ju6h25k/>
  environment.sessionVariables = {
    # NIXOS_OZONE_WL = "1"; disable for now since vs code is broken
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";
    QT_QPA_PLATFORM = "wayland";
  };
}
