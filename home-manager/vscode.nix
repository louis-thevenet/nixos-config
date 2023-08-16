{ config, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      jnoortheen.nix-ide
      ms-vscode.cpptools
      ms-dotnettools.csharp
      ms-vscode.cmake-tools
    ];

    userSettings = {
      "editor.formatOnSave" = true;
      "editor.indent_style" = "space";
      "editor.indentSize" = 4;
      "editor.tabSize" = 4;
      "editor.insertSpaces" = true;
      "editor.detectIndentation" = false;
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "Fira Code";
      "workbench.colorTheme" = "Default Light+";
      "workbench.iconTheme" = "ayu";

      "git.confirmSync" = false;
"cmake.configureOnOpen"= true;


      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.formatterPath" = "nixpkgs-fmt";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = { "command" = [ "nixpkgs-fmt" ]; };
        };
      };
    };
  };
}
