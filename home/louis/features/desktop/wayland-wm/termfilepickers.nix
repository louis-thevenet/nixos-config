{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.xdp-termfilepickers.homeManagerModules.default ];
  services.xdg-desktop-portal-termfilepickers =
    let
      termfilepickers = inputs.xdp-termfilepickers.packages.${pkgs.system}.default;
    in
    {
      enable = true;
      package = termfilepickers;
      config = {
        terminal_command = [
          (lib.getExe pkgs.kitty)
        ];
      };
    };
}
