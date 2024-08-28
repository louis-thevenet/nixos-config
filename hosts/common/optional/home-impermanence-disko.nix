{
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.default
    inputs.impermanence.nixosModule
  ];
  programs.fuse.userAllowOther = true;
  disko.devices = {
    # tmpfs on root
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=8G"
      ];
    };
    # /home too
    nodev."/home" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=8G"
      ];
    };

    disk.main = {
      device = lib.mkDefault "/dev/nvme0n1";
      type = "disk";

      content = {
        type = "gpt";
        partitions = {
          boot = {
            priority = 1;
            name = "boot";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          data = {
            size = "100%";
            content = {
              type = "btrfs";
              subvolumes = {
                nix = {
                  type = "filesystem";
                  mountpoint = "/nix";
                  mountOptions = ["compress=zstd"];
                };
                persist = {
                  type = "filesystem";
                  mountpoint = "/persist";
                  mountOptions = ["compress=zstd"];
                };
                shared = {
                  type = "filesystem";
                  mountpoint = "/shared";
                  mountOptions = ["compress=zstd"];
                };

                log = {
                  type = "filesystem";
                  mountpoint = "/var/log";
                  mountOptions = ["compress=zstd"];
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  # always persist these
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/etc/NetworkManager"
      "/var/lib/bluetooth"
      "/var/lib/private/ollama"
    ];
  };

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';
}
