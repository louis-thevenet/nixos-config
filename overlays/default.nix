{ inputs, ... }:
{
  inherit (inputs.niri.overlays) niri;

  modifications = final: prev: {

    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
    helix-latest = inputs.helix.packages.${prev.stdenv.hostPlatform.system}.helix;
  };

  additions = final: _prev: import ../pkgs { pkgs = final; };
}
