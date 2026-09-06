{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

let
  inherit (config.home-config.cli.commonTools) enable;
  helix = lib.getExe pkgs.helix;
in
{

  imports = [ inputs.yazelix.homeManagerModules.default ];
  home.packages = with pkgs; [
    noto-fonts
  ];
  programs.yazelix = {
    inherit enable;
    # package = inputs.yazelix.packages.${pkgs.system}.yazelix-no-helix-no-yazi;
    package = inputs.yazelix.packages.${pkgs.system}.yazelix-no-helix;
    config = {
      settings = {
        editor.command = helix;
        shell = {
          program = "fish";
          atuin = false;
        };
      };
    };
  };
}
