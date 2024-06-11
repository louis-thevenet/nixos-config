{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.dev;
in {
  programs.vscode = mkIf cfg.vscode.enable {
    enable = true;
    package = pkgs.vscode-fhs;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions;
      [
        mkhl.direnv
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        nvarner.typst-lsp
        tomoki1207.pdf
        vadimcn.vscode-lldb
        #redhat.java
        #vscjava.vscode-gradle
        #vscjava.vscode-java-debug
        #ms-toolsai.jupyter
        #alefragnani.bookmarks
        oderwat.indent-rainbow
        pkief.material-icon-theme
        christian-kohler.path-intellisense
        llvm-vs-code-extensions.vscode-clangd
        eamodio.gitlens
        ocamllabs.ocaml-platform
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "continue";
          publisher = "Continue";
          version = "0.9.79";
          sha256 = "sZLtY30eWO7Tflxd9BazSBNl/d5w/k+Esodu3Qthzos=";
        }
      ];

    keybindings = [
      {
        key = "";
        command = "workbench.view.extensions";
      }

      {
        key = "ctrl+shift+x";
        command = "workbench.action.terminal.toggleTerminal";
      }

      {
        key = "ctrl+u";
        command = "typst-lsp.showPdf";
      }
      {
        "key" = "ctrl+shift+[KeyM]";
        "command" = "toggleVim";
      }
    ];

    userSettings.cmake.configureOnOpen = true;
    userSettings.editor.formatOnSave = true;

    # Indent
    userSettings.editor.detectIndentation = false;
    userSettings.editor.indent_style = "space";
    userSettings.editor.indentSize = 4;
    userSettings.editor.insertSpaces = true;
    userSettings.editor.tabSize = 2;

    userSettings.editor.inlineSuggest.enabled = true;

    # Font
    userSettings.editor.fontLigatures = true;
    userSettings.editor.fontFamily = config.fontProfiles.monospace.family;

    userSettings.explorer.confirmDragAndDrop = false;

    userSettings.files.insertFinalNewLine = true;
    userSettings.files.trimTrailingWhitespace = true;

    userSettings.git.autofetch = true;
    userSettings.git.confirmSync = false;

    userSettings.workbench.iconTheme = "material-icon-theme";

    userSettings.nix.enableLanguageServer = true;
    userSettings.nix.serverPath = "${pkgs.nil}/bin/nil";
    userSettings.nix.formatterPath = "${pkgs.alejandra}/bin/alejandra";
    userSettings.nix.serverSettings.nil.formatting.command = ["alejandra"];

    userSettings.typst-lsp.exportPdf = "onType";
    userSettings.typst-lsp.experimentalFormatterMode = "on";
    userSettings.typst.editor.defaultFormatter = "typst-fmt";

    userSettings.rust-analyzer.checkOnSave = true;
    userSettings.rust-analyzer.check.command = "clippy";

    userSettings."[c]".editor.defaultFormatter = "llvm-vs-code-extensions.vscode-clangd";
  };
}
