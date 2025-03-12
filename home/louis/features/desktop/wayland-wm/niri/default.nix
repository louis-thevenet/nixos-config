{ config, ... }:
let
  dir = "/home/louis/src/nixos-config/home/louis/features/desktop/wayland-wm/albert";
in
{
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${dir}/config.kdl";
}
