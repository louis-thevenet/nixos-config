{ inputs, pkgs, ... }:
{

  environment.systemPackages = [
    inputs.winapps.packages."${pkgs.stdenv.hostPlatform.system}".winapps
    inputs.winapps.packages."${pkgs.stdenv.hostPlatform.system}".winapps-launcher # optional
  ];
}
