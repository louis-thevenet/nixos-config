{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = (pkgs.vscode.override {isInsiders = true;}).overrideAttrs (oldAttrs: {
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
        vadimcn.vscode-lldb
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

    userSettings.workbench.colorTheme = "Github";
    userSettings.workbench.iconTheme = "ayu";

    userSettings.nix.enableLanguageServer = true;
    userSettings.nix.serverPath = "${pkgs.nil}/bin/nil";
    userSettings.nix.formatterPath = "${pkgs.alejandra}/bin/alejandra";
    userSettings.nix.serverSettings.nil.formatting.command = ["alejandra"];

    userSettings.typst-lsp.exportPdf = "onType";
  };
}
