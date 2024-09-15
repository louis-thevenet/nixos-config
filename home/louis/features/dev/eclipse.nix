{
  pkgs,
  lib,
  ...
}: {
  programs.eclipse = {
    enable = true;
    plugins = with pkgs.eclipses; [
      eclipse-modeling
    ];
    # plugins = with pkgs.eclipses; [
    #   (plugins.buildEclipseUpdateSite {
    #     name = "acceleo3.7.17";
    #     src = pkgs.fetchurl {
    #       url = "https://github.com/eclipse-acceleo/acceleo/archive/refs/tags/3.7.17.zip";
    #       hash = "sha256-7SPAEuuOSBHkQpHdiMYTDRdWHkPjZAzeWOMehYM/mDk=";
    #     };
    #   })
    #   (plugins.buildEclipseUpdateSite {
    #     name = "sirius-web";
    #     src = pkgs.fetchurl {
    #       url = "https://github.com/eclipse-atl/atl/releases/download/v4.10.0/ATL-Updates-4.10.0.zip";
    #       hash = "sha256-ntQQMQksQJIqEUtnifNl7BK6ivx8nDBvCVZX1SPpmQU=";
    #     };
    #   })
    #   (plugins.buildEclipseUpdateSite {
    #     name = "atl";
    #     src = pkgs.fetchurl {
    #       url = "https://github.com/eclipse-atl/atl/releases/download/v4.10.0/ATL-Updates-4.10.0.zip";
    #       hash = "sha256-1mpaIgT3C5Ipm0auWehPTuVLaYmGxI3xRHwc4EQ9TxE=";
    #     };
    #   })
    # ];
  };
}
