{ config, pkgs, ... }: {
  programs.vscode = {
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
    ];

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
}
