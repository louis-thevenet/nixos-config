{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  programs.hyprland = {
    xwayland.enable = true;
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
}
