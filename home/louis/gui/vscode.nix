{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions;
      [
        arrterian.nix-env-selector
        jnoortheen.nix-ide
        ms-vscode.cpptools
        ms-dotnettools.csharp
        ms-python.python
        ms-vscode.cmake-tools
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "ada";
          publisher = "AdaCore";
          version = "23.0.21";
          sha256 = "4vEBF183X+w2zidSrnQlmUcDlXsUayhxCp1h+GikWIU=";
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
    ];

    userSettings = {
      cmake = {
        configureOnOpen = true;
      };
      editor = {
        formatOnSave = true;

        # Indent
        detectIndentation = false;
        indent_style = "space";
        indentSize = 4;
        insertSpaces = true;
        tabSize = 4;

        inlineSuggest.enabled = true;

        # Font
        fontLigatures = true;
        fontFamily = "Fira Code";
      };
      explorer = {
        confirmDragAndDrop = false;
      };
      files = {
        insertFinalNewLine = true;
        trimTrailingWhitespace = true;
      };
      git = {
        autofetch = true;
        confirmSync = false;
      };
      workbench = {
        colorTheme = "Solarized Light";
        iconTheme = "ayu";
      };
      nix = {
        enableLanguageServer = true;
        serverPath = "${pkgs.nil}/bin/nil";
        formatterPath = "${pkgs.alejandra}/bin/alejandra";
        serverSettings = {
          nil = {
            formatting = {command = ["alejandra"];};
          };
        };
      };
    };
  };
}
