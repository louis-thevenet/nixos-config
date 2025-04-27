{
  config,
  ...
}:
let
  inherit (config.home-config.cli.commonTools) enable;
in
{
  programs.yazi = {
    inherit enable;
    enableFishIntegration = true;
  };
}
