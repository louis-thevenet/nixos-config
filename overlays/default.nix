{ inputs, ... }:
{
  inherit (inputs.niri.overlays) niri;

  modifications = final: prev: {

    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
    helix-latest = inputs.helix.packages.${prev.system}.helix;
  };
}
