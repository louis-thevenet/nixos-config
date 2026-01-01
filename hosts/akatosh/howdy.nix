{ inputs, pkgs, ... }:
{
  disabledModules = [ "security/pam.nix" ];
  imports = [
    "${inputs.nixpkgs-howdy}/nixos/modules/security/pam.nix"
    "${inputs.nixpkgs-howdy}/nixos/modules/services/security/howdy"
    "${inputs.nixpkgs-howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"
  ];
  nixpkgs.overlays = [
    (
      let
        pkgs-howdy = inputs.nixpkgs-howdy.legacyPackages."x86_64-linux";
      in
      _: _: {
        inherit (pkgs-howdy) howdy;
      }

    )
  ];
  security.pam.services.login.howdyAuth = false;
  services = {
    howdy = {
      enable = true;
      package = pkgs.howdy;
      settings = {
        core = {
          abort_if_ssh = true;
        };
        video.dark_threshold = 90;
        video.timeout = 2;
      };
    };

    linux-enable-ir-emitter = {
      enable = true;
      package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.linux-enable-ir-emitter;
    };
  };
}
