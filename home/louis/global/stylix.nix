{
  pkgs,
  lib,
  config,
  ...
}: {
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://images.pexels.com/photos/167698/pexels-photo-167698.jpeg?auto=compress&cs=tinysrgb&w=2560&h=1920&dpr=1";
      sha256 = "sha256-z/fLJ/0mSLCnhseg5NFWqlwAWnJOJkRpju6NCSiu9b4=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/equilibrium-gray-light.yaml";
    cursor = {
      package = pkgs.numix-cursor-theme;
      name = "Numix-Cursor-Light";
      size = 22;
    };
    fonts = {
      monospace = {
        name = "FiraCode Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
  };
}
