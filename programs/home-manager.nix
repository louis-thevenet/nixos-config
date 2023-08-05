{ config, pkgs, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    users.louis = { pkgs, ... }: {
      home.packages = with pkgs; [
      ];



      programs = {
        vscode = {
          enable = true;
          package = pkgs.vscodium;
          enableExtensionUpdateCheck = false;
          enableUpdateCheck = false;
          mutableExtensionsDir = false;
          extensions = with pkgs.vscode-extensions; [
            matklad.rust-analyzer
            ms-dotnettools.csharp
            rust-lang.rust-analyzer
            ms-vscode.cpptools
            jnoortheen.nix-ide
          ]; #++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [ 
          #{
          #  name = "nunjucks-template";
          #  publisher = "eseom";
          #  version = "0.5.1";
          #  sha256 = "CkHPyLZMtyLmqEzRMBqjxHV51R3AYrt8RJ5JQN1egWI=";
          #}
          #];
          userSettings = {
            "editor.formatOnSave" = true;
            "editor.indent_style" = "space";
            "editor.indentSize" = 4;
            "editor.tabSize" = 4;
            "editor.insertSpaces" = true;
            "editor.detectIndentation" = false;
            "workbench.colorTheme" = "Default Light+";
            "workbench.iconTheme" = "ayu";
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nil";
            "nix.formatterPath" = "nixpkgs-fmt";
            "nix.serverSettings" = {
              "nil" = {
                "formatting" = { "command" = [ "nixpkgs-fmt" ]; };
              };
            };
            "git.enableCommitSigning" = true;
          };
        };
      };


      imports =
        [ ];

      home = {
        stateVersion = "23.05";
        username = "louis";
      };
    };





  };
  users.users.louis = {
    home = "/home/louis";
    extraGroups = [ "wheel" "networkmanager" ];
    isNormalUser = true;
  };
}
