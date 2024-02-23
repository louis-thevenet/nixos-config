{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    #"${pkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    #"${pkgs}/nixos/modules/installer/cd-dvd/channel.nix"

    ../common/global
    ../common/users/louis
    ../optional/gnome.nix
  ];

  networking.hostName = "iso";
  services = {
    qemuGuest.enable = true;

    xserver = {
      enable = true;
      xkb.layout = "fr";
      desktopManager.gnome = {
        enable = true;
      };
      displayManager.gdm = {
        enable = true;
      };
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
  };

  systemd = {
    services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  users.extraUsers.root.password = "nixos";
}
