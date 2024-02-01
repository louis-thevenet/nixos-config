{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.scheduler = mkOption {
    type = types.submodule {
      options = {
        enable = lib.mkEnableOption "Scheduler service";
        name = mkOption {
          type = types.str;
          description = "Name of the instance";
          default = "scheduler";
        };
        filePath = lib.mkOption {
          type = with lib.types; either path str;
          description = "Path to the target file.";
        };

        versions = mkOption {
          type = types.listOf (types.submodule {
            options = {
              content = mkOption {
                type = types.str;
                description = "Content to add";
                default = [];
              };

              start = mkOption {
                type = types.str;
                description = "Time at which the scheduler inserts this content";
                default = "";
              };
            };
          });
        };
      };
    };
  };

  config = lib.mkIf config.scheduler.enable {
    systemd.user.services =
      listToAttrs
      (map
        (version: {
          name = "${config.scheduler.name}";
          value = {
            Unit = {
              description = "Change version of ${config.scheduler.filePath} at ${version.start}";
            };
            Install = {
              wantedBy = ["default.target"];
            };
            Service = {
              ExecStart = "touch ${config.scheduler.filePath}/test";
            };
          };
        })
        config.scheduler.versions);
  };
}
