{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.darkman;

  yamlFormat = pkgs.formats.yaml {};

  scriptsOptionType = kind:
    mkOption {
      type = types.oneOf [types.path types.lines];
      default = "";
      example = literalExpression ''
          '''
            ''${pkgs.dconf}/bin/dconf write \
                /org/gnome/desktop/interface/color-scheme "'prefer-${kind}'"
          ''';
        }
      '';
      description = ''
        Script to run when switching to "${kind} mode".

        Multiline strings are interpreted as Bash shell scripts and a shebang is
        not required.
      '';
    };
in {
  meta.maintainers = [maintainers.xlambein];

  options.services.darkman = {
    enable = mkEnableOption ''
      darkman, a tool that automatically switches dark-mode on and off based on
      the time of the day'';

    package = mkPackageOption pkgs "darkman" {};

    settings = mkOption {
      type = types.submodule {freeformType = yamlFormat.type;};
      default = {};
      example = literalExpression ''
        {
          lat = 52.3;
          lng = 4.8;
          usegeoclue = true;
        }
      '';
      description = ''
        Settings for the {command}`darkman` command. See
        <https://darkman.whynothugo.nl/#CONFIGURATION> for details.
      '';
    };

    darkModeScript = scriptsOptionType "dark";
    lightModeScript = scriptsOptionType "light";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package pkgs.dbus];

    environment.etc."xdg/darkman/config.yaml".source = yamlFormat.generate "darkman-config.yaml" cfg.settings;
    environment.etc."darkman-scripts/dark-mode.d/activate".source = pkgs.writeShellScript "activate" cfg.darkModeScript;
    environment.etc."darkman-scripts/light-mode.d/activate".source = pkgs.writeShellScript "activate" cfg.lightModeScript;

    systemd.user.services.darkman = {
      description = "Darkman system service";
      enable = true;
      environment = {
        XDG_DATA_DIRS = "/etc/darkman-scripts";
      };
      serviceConfig = {
        Type = "dbus";
        BusName = "nl.whynothugo.darkman";
        ExecStart = "${getExe cfg.package} run";
        Restart = "on-failure";
        TimeoutStopSec = 15;
        Slice = "background.slice";
      };

      wantedBy = mkDefault ["multi-user.target"];
    };
  };
}
