{ config, ... }:
let
  cfg = config.home-config.cli;
in
{
  programs.yazi.enable = cfg.commonTools.enable;
}
