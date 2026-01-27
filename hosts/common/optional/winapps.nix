{ inputs, pkgs, ... }:
{

  environment.systemPackages = [
    inputs.winapps.packages."${pkgs.system}".winapps
    inputs.winapps.packages."${pkgs.system}".winapps-launcher # optional
  ];
}
