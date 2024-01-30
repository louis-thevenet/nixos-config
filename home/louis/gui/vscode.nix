{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;

    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions;
      [
        mkhl.direnv
        jnoortheen.nix-ide
        ms-vscode.cpptools
        #ms-dotnettools.csharp
        #ms-python.python
        #ms-vscode.cmake-tools
        rust-lang.rust-analyzer
        vadimcn.vscode-lldb
        nvarner.typst-lsp
        tomoki1207.pdf
        github.copilot
        github.copilot-chat
        redhat.java
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "ada";
          publisher = "AdaCore";
          version = "23.0.21";
          sha256 = "4vEBF183X+w2zidSrnQlmUcDlXsUayhxCp1h+GikWIU=";
        }
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "wgsl";
          publisher = "polymeilex";
          version = "0.1.16";
          sha256 = "sha256-0EcV80N8u3eQB74TNedjM5xbQFY7avUu3A8HWi7eZLk=";
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
    ];

    userSettings.cmake.configureOnOpen = true;
    userSettings.editor.formatOnSave = true;

    # Indent
    userSettings.editor.detectIndentation = false;
    userSettings.editor.indent_style = "space";
    userSettings.editor.indentSize = 4;
    userSettings.editor.insertSpaces = true;
    userSettings.editor.tabSize = 4;

    userSettings.editor.inlineSuggest.enabled = true;

    # Font
    userSettings.editor.fontLigatures = true;
    userSettings.editor.fontFamily = "Fira Code";

    userSettings.explorer.confirmDragAndDrop = false;

    userSettings.files.insertFinalNewLine = true;
    userSettings.files.trimTrailingWhitespace = true;

    userSettings.git.autofetch = true;
    userSettings.git.confirmSync = false;

    userSettings.workbench.colorTheme = "Solarized Light";
    userSettings.workbench.iconTheme = "ayu";

    userSettings.nix.enableLanguageServer = true;
    userSettings.nix.serverPath = "${pkgs.nil}/bin/nil";
    userSettings.nix.formatterPath = "${pkgs.alejandra}/bin/alejandra";
    userSettings.nix.serverSettings.nil.formatting.command = ["alejandra"];

    userSettings.typst-lsp.exportPdf = "onType";
    userSettings.typst-lsp.experimentalFormatterMode = "on";
    userSettings.typst.editor.defaultFormatter = "typst-fmt";

    userSettings.rust-analyzer.checkOnSave = true;
    userSettings.rust-analyzer.check.command = "clippy";

    # Temp fix since vscode is broken under wayland
    userSettings.window.titleBarStyle = "custom";
  };
}
