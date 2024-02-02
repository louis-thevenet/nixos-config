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

        versions = let
          t = types.listOf (types.submodule {
            options = {
              file = mkOption {
                type = types.str;
                description = "Path to the file to change";
              };

              content = mkOption {
                type = types.str;
                description = "Content to add";
                default = "";
              };
            };
          });
        in
          mkOption {
            type = types.attrsOf t;
            default = {};
          };
      };
    };
  };

  config = lib.mkIf config.scheduler.enable {
    systemd.user.services = listToAttrs (
      elemAt
      (
        attrValues
        (
          mapAttrs (
            time: files:
              map (entry: {
                name = "scheduler-${time}-${entry.file}";
                value = {
                  Unit = {
                    Description = "Change version of ${entry.file} at ${time}";
                  };
                  Install = {
                    WantedBy = ["default.target"];
                  };
                  Service = {
                    #ExecStart = "${pkgs.coreutils}/bin/cp ${config.scheduler.filePath} ${config.scheduler.filePath}.bak";
                    ExecStart = ''${pkgs.noti}/bin/noti "${entry.content}"'';
                  };
                };
              })
              files
          )
          config.scheduler.versions
        )
      )
      0
    );

    systemd.user.timers = listToAttrs (
      elemAt
      (
        attrValues
        (
          mapAttrs (
            time: files:
              map (entry: {
                name = "scheduler-${time}-${entry.file}";
                value = {
                  Install.WantedBy = ["timers.target"];
                  Timer = {
                    Unit = "scheduler-${time}-${entry.file}";
                    OnCalendar = "${time}";
                    Persistent = true;
                  };
                };
              })
              files
          )
          config.scheduler.versions
        )
      )
      0
    );
  };
}
