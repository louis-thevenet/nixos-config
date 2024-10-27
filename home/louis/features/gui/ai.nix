{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.home-config.gui.ai;
in
{
  home.packages = mkMerge [
    (mkIf cfg.lmstudio.enable [
      pkgs.lmstudio
    ])
    (mkIf cfg.comfyUI.enable [
      inputs.nix-ai-stuff.packages.${pkgs.system}.comfyui
    ])
  ];
}
