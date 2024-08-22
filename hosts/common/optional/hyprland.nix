{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
  };

  # XDG Portals
  xdg = {
    portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      xdgOpenUsePortal = true;
    };
  };

  imports = [inputs.xdp-termfilepickers.nixosModules.default];

  services.xdg-desktop-portal-termfilepickers = let
    termfilepickers = inputs.xdp-termfilepickers.packages.${pkgs.system}.default;
  in {
    enable = true;
    package = termfilepickers;
    desktopEnvironments = ["hyprland"];
    config = {
      save_file_script_path = "${termfilepickers}/share/wrappers/yazi-save-file.nu";
      open_file_script_path = "${termfilepickers}/share/wrappers/yazi-open-file.nu";
      save_files_script_path = "${termfilepickers}/share/wrappers/yazi-save-file.nu";
      terminal_command = lib.getExe pkgs.kitty;
    };
  };

  environment.systemPackages = [
    pkgs.xdg-utils # xdg-open
    pkgs.qt5.qtwayland
    pkgs.qt6.qtwayland
  ];

  # Mostly from <https://www.reddit.com/r/NixOS/comments/137j18j/comment/ju6h25k/>
  environment.sessionVariables =
    {
      NIXOS_OZONE_WL = "1";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      CLUTTER_BACKEND = "wayland";
      WLR_RENDERER = "vulkan";
    }
    // lib.mkIf (config.hardware.nvidia.package != null) {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };
}
