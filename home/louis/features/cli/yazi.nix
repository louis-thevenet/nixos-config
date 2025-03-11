{
  pkgs,
  inputs,
  config,
  ...
}:
let
  inherit (config.home-config.cli.commonTools) enable;
in
{
  programs.yazi = {
    inherit enable;
    package = inputs.yazi.packages.${pkgs.system}.yazi;
  };
}
