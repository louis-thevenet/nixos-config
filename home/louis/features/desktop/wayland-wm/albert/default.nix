{
  config,
  pkgs,
  ...
}:
{
  home = {
    # used by plugins
    sessionVariables."GOLDENDICT_FORCE_WAYLAND" = "1";
    packages = [
      pkgs.goldendict-ng
      pkgs.libnotify
    ];
  };

  services.albert.enable = true;

  xdg.configFile =
    let
      dir = "/home/louis/src/nixos-config/home/louis/features/desktop/wayland-wm/albert";
    in
    {
      # out of store while still in the learning phase
      "albert/config".source = config.lib.file.mkOutOfStoreSymlink "${dir}/config.toml";
      "albert/websearch/engines.json".source =
        config.lib.file.mkOutOfStoreSymlink "${dir}/websearch-engines.json";
    };
}
