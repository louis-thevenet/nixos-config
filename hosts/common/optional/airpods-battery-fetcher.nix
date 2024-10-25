{
  config,
  pkgs,
  ...
}:
{
  systemd.user.services.airpods-battery-fetcher = {
    description = "AirPods Battery Fetcher for zsh plugin";
    path = [ pkgs.python310 ];
    serviceConfig = {
      ExecStart = "${
        (pkgs.python3.withPackages (ps: with ps; [ bleak ]))
      }/bin/python3 /home/louis/src/zsh-airpods-battery/fetch_airpods_battery.py";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
    enable = true;
  };
}
