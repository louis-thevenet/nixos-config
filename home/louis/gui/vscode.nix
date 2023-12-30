{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = (pkgs.vscode.override {isInsiders = true;}).overrideAttrs (oldAttrs: rec {
      src = builtins.fetchTarball {
        url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/9621add46007f7a1ab37d1fce9bcdcecca62aeb0/code-insider-x64-1703050604.tar.gz";
        sha256 = "017630xgr64qjva73imb56fcqr858xfcsbdgq97akawlxf1ydm5a";
      };
      version = "latest";

      buildInputs = oldAttrs.buildInputs ++ [pkgs.krb5];
    });
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions;
      [
        mkhl.direnv
        jnoortheen.nix-ide
        #ms-vscode.cpptools
        #ms-dotnettools.csharp
        #ms-python.python
        #ms-vscode.cmake-tools
        rust-lang.rust-analyzer
        nvarner.typst-lsp
        tomoki1207.pdf
        github.copilot
        github.copilot-chat
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
        colorTheme = "Github";
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
      typst-lsp = {
        exportPdf = "onType";
      };
    };
  };
}
