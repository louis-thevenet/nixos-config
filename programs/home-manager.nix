{ config, pkgs, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    users.louis = {
      programs = import ./vscode.nix
        {
          pkgs = pkgs;
        };

      home.packages = with pkgs; [
      ];

      home = {
        stateVersion = "23.05";
        username = "louis";
      };
    };
  };
}

