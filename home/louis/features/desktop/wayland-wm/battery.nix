{
  pkgs,
  lib,
  ...
}:
{
  systemd.user.services.low-battery-notify = {
    Unit = {
      Description = "Sends a notification when battery is lower than 20%";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart =
        let
          notify-send = lib.getExe pkgs.libnotify;
          cat = lib.getExe' pkgs.coreutils "cat";
          sleep = lib.getExe' pkgs.coreutils "sleep";
        in
        "${pkgs.writeShellScript "low-battery-notify" ''
          #!/run/current-system/sw/bin/bash
          while true; do
            bat_lvl=$(${cat} /sys/class/power_supply/BAT1/capacity)
            if [ "$bat_lvl" -le 15 ]; then
             ${notify-send} --urgency=CRITICAL "Low Battery" "Level: ''${bat_lvl}%"
              ${sleep} 1200
            else
              ${sleep} 120
            fi
          done
        ''}";
    };
  };
}
