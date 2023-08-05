{ config, pkgs, ... }: {
  home-manager = {
    useGlobalPkgs = true;

    users.louis = { pkgs, ... }: {
      home.packages = with pkgs; [
      ];

      programs.vscode = import ./vscode.nix {
        pkgs = pkgs;
      };

      home = {
        stateVersion = "23.05";
        username = "louis";
      };
    };

  };
}

