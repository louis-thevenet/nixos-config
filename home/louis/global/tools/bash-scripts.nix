{pkgs, ...}: let
  cpu-cores-disable = pkgs.writeShellScriptBin "cpu-core-disable" ''
    #!/usr/bin/env bash

    core_count=$1

    echo "Restoring all cores"
    for i in {1..19}; do
      echo 1 | sudo tee /sys/devices/system/cpu/cpu"$i"/online
    done

    echo "Disabling $core_count cores"
    for ((i = 20-"$core_count"; i <=19 ; i++)); do
      echo 0 | sudo tee /sys/devices/system/cpu/cpu"$i"/online
    done
  '';
in {
  home.packages = [
    cpu-cores-disable
  ];
}
