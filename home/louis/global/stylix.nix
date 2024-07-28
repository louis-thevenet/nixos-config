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
    base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
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

  services.darkman = let
    find-hm-generation = let
      home-manager = "${pkgs.home-manager}/bin/home-manager";
      grep = "${pkgs.toybox}/bin/grep";
      head = "${pkgs.toybox}/bin/head";
      find = "${pkgs.toybox}/bin/find";
    in ''

      for line in $(${home-manager} generations | ${grep} -o '/.*')
      do
        res=$(${find} $line | ${grep} specialisation | ${head} -1)
        output=$?
        if [[ $output -eq 0 ]] && [[ $res != "" ]]; then
            echo $res
            exit
        fi
      done
    '';
  in {
    enable = true;
    darkModeScripts = {
      activate = ''
        $(${find-hm-generation})/dark/activate
        swaync-client -rs # reload CSS for swaync (notification center)
      '';
    };
    lightModeScripts = {
      activate = ''
        $(${find-hm-generation})/light/activate
        swaync-client -rs # reload CSS for swaync (notification center)
      '';
    };
    settings = {
      lat = 48.86;
      lng = 2.35;
      dbusserver = true;
    };
  };

  specialisation = {
    light.configuration = {
      stylix.base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
    };

    dark.configuration = {
      stylix.base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
    };
  };
}
