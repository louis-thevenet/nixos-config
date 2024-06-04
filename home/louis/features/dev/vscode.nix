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

    userSettings.workbench.colorTheme = "Solarized Light";
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

    # userSettings.workbench.colorCustomizations = let
    #   inherit (config.colorscheme) colors;
    # in {
    #   "foreground" = "#${palette.base05}";
    #   "widget.shadow" = "#${palette.base00}";
    #   "selection.background" = "#${palette.base0D}";
    #   "descriptionForeground" = "#${palette.base03}";
    #   "errorForeground" = "#${palette.base08}";
    #   "icon.foreground" = "#${palette.base04}";

    #   "textBlockQuote.background" = "#${palette.base01}";
    #   "textBlockQuote.border" = "#${palette.base0D}";
    #   "textCodeBlock.background" = "#${palette.base00}";
    #   "textLink.activeForeground" = "#${palette.base0C}";
    #   "textLink.foreground" = "#${palette.base0D}";
    #   "textPreformat.foreground" = "#${palette.base0D}";
    #   "textSeparator.foreground" = "#f0f";

    #   "button.background" = "#${palette.base01}";
    #   "button.foreground" = "#${palette.base07}";
    #   "button.hoverBackground" = "#${palette.base04}";
    #   "button.secondaryForeground" = "#${palette.base07}";
    #   "button.secondaryBackground" = "#${palette.base0E}";
    #   "button.secondaryHoverBackground" = "#${palette.base04}";
    #   "checkbox.background" = "#${palette.base00}";
    #   "checkbox.foreground" = "#${palette.base05}";

    #   "dropdown.background" = "#${palette.base00}";
    #   "dropdown.listBackground" = "#${palette.base00}";

    #   "dropdown.foreground" = "#${palette.base05}";

    #   "input.background" = "#${palette.base00}";

    #   "input.foreground" = "#${palette.base05}";
    #   "input.placeholderForeground" = "#${palette.base03}";
    #   "inputOption.activeBackground" = "#${palette.base02}";
    #   "inputOption.activeBorder" = "#${palette.base09}";
    #   "inputOption.activeForeground" = "#${palette.base05}";
    #   "inputValidation.errorBackground" = "#${palette.base08}";
    #   "inputValidation.errorForeground" = "#${palette.base05}";
    #   "inputValidation.errorBorder" = "#${palette.base08}";
    #   "inputValidation.infoBackground" = "#${palette.base0D}";
    #   "inputValidation.infoForeground" = "#${palette.base05}";
    #   "inputValidation.infoBorder" = "#${palette.base0D}";
    #   "inputValidation.warningBackground" = "#${palette.base0A}";
    #   "inputValidation.warningForeground" = "#${palette.base05}";
    #   "inputValidation.warningBorder" = "#${palette.base0A}";

    #   "scrollbar.shadow" = "#${palette.base01}";
    #   "scrollbarSlider.activeBackground" = "#${palette.base04}";
    #   "scrollbarSlider.background" = "#${palette.base02}";
    #   "scrollbarSlider.hoverBackground" = "#${palette.base03}";

    #   "badge.background" = "#${palette.base00}";
    #   "badge.foreground" = "#${palette.base05}";

    #   "progressBar.background" = "#${palette.base03}";

    #   "list.activeSelectionBackground" = "#${palette.base02}";
    #   "list.activeSelectionForeground" = "#${palette.base05}";
    #   "list.dropBackground" = "#${palette.base07}";
    #   "list.focusBackground" = "#${palette.base02}";
    #   "list.focusForeground" = "#${palette.base05}";
    #   "list.highlightForeground" = "#${palette.base07}";
    #   "list.hoverBackground" = "#${palette.base03}";
    #   "list.hoverForeground" = "#${palette.base05}";
    #   "list.inactiveSelectionBackground" = "#${palette.base02}";
    #   "list.inactiveSelectionForeground" = "#${palette.base05}";
    #   "list.inactiveFocusBackground" = "#${palette.base02}";
    #   "list.invalidItemForeground" = "#${palette.base08}";
    #   "list.errorForeground" = "#${palette.base08}";
    #   "list.warningForeground" = "#${palette.base0A}";
    #   "listFilterWidget.background" = "#${palette.base00}";

    #   "listFilterWidget.noMatchesOutline" = "#${palette.base08}";
    #   "list.filterMatchBackground" = "#${palette.base02}";

    #   "tree.indentGuidesStroke" = "#${palette.base05}";

    #   "activityBar.background" = "#${palette.base00}";
    #   "activityBar.dropBackground" = "#${palette.base07}";

    #   "activityBar.foreground" = "#${palette.base05}";
    #   "activityBar.inactiveForeground" = "#${palette.base03}";

    #   "activityBarBadge.background" = "#${palette.base0D}";
    #   "activityBarBadge.foreground" = "#${palette.base07}";

    #   "activityBar.activeBackground" = "#${palette.base02}";

    #   "sideBar.background" = "#${palette.base01}";
    #   "sideBar.foreground" = "#${palette.base05}";

    #   "sideBar.dropBackground" = "#${palette.base02}";
    #   "sideBarTitle.foreground" = "#${palette.base05}";
    #   "sideBarSectionHeader.background" = "#${palette.base03}";
    #   "sideBarSectionHeader.foreground" = "#${palette.base05}";

    #   "minimap.findMatchHighlight" = "#${palette.base0A}";
    #   "minimap.selectionHighlight" = "#${palette.base02}";
    #   "minimap.errorHighlight" = "#${palette.base08}";
    #   "minimap.warningHighlight" = "#${palette.base0A}";
    #   "minimap.background" = "#${palette.base00}";

    #   "minimapGutter.addedBackground" = "#${palette.base0B}";
    #   "minimapGutter.modifiedBackground" = "#${palette.base0E}";
    #   "minimapGutter.deletedBackground" = "#${palette.base08}";

    #   "editorGroup.background" = "#${palette.base00}";

    #   "editorGroup.dropBackground" = "#${palette.base02}";
    #   "editorGroupHeader.noTabsBackground" = "#${palette.base01}";
    #   "editorGroupHeader.tabsBackground" = "#${palette.base01}";

    #   "editorGroup.emptyBackground" = "#${palette.base00}";

    #   "tab.activeBackground" = "#${palette.base00}";
    #   "tab.unfocusedActiveBackground" = "#${palette.base00}";
    #   "tab.activeForeground" = "#${palette.base05}";

    #   "tab.inactiveBackground" = "#${palette.base01}";

    #   "tab.inactiveForeground" = "#${palette.base03}";
    #   "tab.unfocusedActiveForeground" = "#${palette.base04}";
    #   "tab.unfocusedInactiveForeground" = "#${palette.base03}";
    #   "tab.hoverBackground" = "#${palette.base02}";

    #   "tab.unfocusedHoverBackground" = "#${palette.base02}";

    #   "tab.activeModifiedBorder" = "#${palette.base0D}";
    #   "tab.inactiveModifiedBorder" = "#${palette.base0D}";
    #   "tab.unfocusedActiveModifiedBorder" = "#${palette.base0D}";
    #   "tab.unfocusedInactiveModifiedBorder" = "#${palette.base0D}";
    #   "editorPane.background" = "#${palette.base00}";

    #   "editor.background" = "#${palette.base00}";
    #   "editor.foreground" = "#${palette.base05}";
    #   "editorLineNumber.foreground" = "#${palette.base03}";
    #   "editorLineNumber.activeForeground" = "#${palette.base04}";

    #   "editorCursor.foreground" = "#${palette.base05}";
    #   "editor.selectionBackground" = "#${palette.base05}";
    #   "editor.selectionForeground" = "#${palette.base00}";

    #   "editor.inactiveSelectionBackground" = "#${palette.base02}";
    #   "editor.selectionHighlightBackground" = "#${palette.base01}";

    #   "editor.wordHighlightBackground" = "#${palette.base02}";

    #   "editor.wordHighlightStrongBackground" = "#${palette.base03}";

    #   "editor.findMatchBackground" = "#${palette.base0A}";
    #   "editor.findMatchHighlightBackground" = "#${palette.base09}";
    #   "editor.findRangeHighlightBackground" = "#${palette.base01}";

    #   "editor.hoverHighlightBackground" = "#${palette.base02}";
    #   "editor.lineHighlightBackground" = "#${palette.base01}";

    #   "editorLink.activeForeground" = "#${palette.base0D}";
    #   "editor.rangeHighlightBackground" = "#${palette.base01}";

    #   "editorWhitespace.foreground" = "#${palette.base03}";
    #   "editorIndentGuide.background" = "#${palette.base03}";
    #   "editorIndentGuide.activeBackground" = "#${palette.base04}";
    #   "editorRuler.foreground" = "#${palette.base03}";

    #   "editorCodeLens.foreground" = "#${palette.base02}";

    #   "editorLightBulb.foreground" = "#${palette.base0A}";
    #   "editorLightBulbAutoFix.foreground" = "#${palette.base0D}";
    #   "editorBracketMatch.background" = "#${palette.base02}";

    #   "editorOverviewRuler.findMatchForeground" = "#${palette.base0A}";
    #   "editorOverviewRuler.rangeHighlightForeground" = "#${palette.base03}";
    #   "editorOverviewRuler.selectionHighlightForeground" = "#${palette.base02}";
    #   "editorOverviewRuler.wordHighlightForeground" = "#${palette.base07}";
    #   "editorOverviewRuler.wordHighlightStrongForeground" = "#${palette.base0D}";
    #   "editorOverviewRuler.modifiedForeground" = "#${palette.base0E}";
    #   "editorOverviewRuler.addedForeground" = "#${palette.base0B}";
    #   "editorOverviewRuler.deletedForeground" = "#${palette.base08}";
    #   "editorOverviewRuler.errorForeground" = "#${palette.base08}";
    #   "editorOverviewRuler.warningForeground" = "#${palette.base0A}";
    #   "editorOverviewRuler.infoForeground" = "#${palette.base0C}";
    #   "editorOverviewRuler.bracketMatchForeground" = "#${palette.base06}";

    #   "editorError.foreground" = "#${palette.base08}";

    #   "editorWarning.foreground" = "#${palette.base0A}";

    #   "editorInfo.foreground" = "#${palette.base0C}";

    #   "editorHint.foreground" = "#${palette.base0D}";

    #   "problemsErrorIcon.foreground" = "#${palette.base08}";
    #   "problemsWarningIcon.foreground" = "#${palette.base0A}";
    #   "problemsInfoIcon.foreground" = "#${palette.base0C}";

    #   "editorGutter.addedBackground" = "#${palette.base0B}";
    #   "editorGutter.background" = "#${palette.base00}";
    #   "editorGutter.deletedBackground" = "#${palette.base08}";
    #   "editorGutter.modifiedBackground" = "#${palette.base0E}";
    #   "editorGutter.commentRangeForeground" = "#${palette.base04}";
    #   "editorGutter.foldingControlForeground" = "#${palette.base05}";

    #   "diffEditor.insertedTextBackground" = "#${palette.base0B}";

    #   "diffEditor.removedTextBackground" = "#${palette.base08}";

    #   "diffEditor.diagonalFill" = "#${palette.base02}";

    #   "editorWidget.foreground" = "#${palette.base05}";
    #   "editorWidget.background" = "#${palette.base00}";

    #   "editorSuggestWidget.background" = "#${palette.base01}";

    #   "editorSuggestWidget.foreground" = "#${palette.base05}";
    #   "editorSuggestWidget.highlightForeground" = "#${palette.base0D}";
    #   "editorSuggestWidget.selectedBackground" = "#${palette.base02}";
    #   "editorHoverWidget.foreground" = "#${palette.base05}";
    #   "editorHoverWidget.background" = "#${palette.base00}";

    #   "debugExceptionWidget.background" = "#${palette.base01}";

    #   "editorMarkerNavigation.background" = "#${palette.base01}";
    #   "editorMarkerNavigationError.background" = "#${palette.base08}";
    #   "editorMarkerNavigationWarning.background" = "#${palette.base0A}";
    #   "editorMarkerNavigationInfo.background" = "#${palette.base0D}";

    #   "peekViewEditor.background" = "#${palette.base01}";
    #   "peekViewEditorGutter.background" = "#${palette.base01}";
    #   "peekViewEditor.matchHighlightBackground" = "#${palette.base09}";

    #   "peekViewResult.background" = "#${palette.base00}";
    #   "peekViewResult.fileForeground" = "#${palette.base05}";
    #   "peekViewResult.lineForeground" = "#${palette.base03}";
    #   "peekViewResult.matchHighlightBackground" = "#${palette.base09}";
    #   "peekViewResult.selectionBackground" = "#${palette.base02}";
    #   "peekViewResult.selectionForeground" = "#${palette.base05}";
    #   "peekViewTitle.background" = "#${palette.base02}";
    #   "peekViewTitleDescription.foreground" = "#${palette.base03}";
    #   "peekViewTitleLabel.foreground" = "#${palette.base05}";

    #   "merge.currentContentBackground" = "#${palette.base0D}";
    #   "merge.currentHeaderBackground" = "#${palette.base0D}";
    #   "merge.incomingContentBackground" = "#${palette.base0B}";
    #   "merge.incomingHeaderBackground" = "#${palette.base0B}";

    #   "editorOverviewRuler.currentContentForeground" = "#${palette.base0D}";
    #   "editorOverviewRuler.incomingContentForeground" = "#${palette.base0B}";
    #   "editorOverviewRuler.commonContentForeground" = "#${palette.base0F}";

    #   "panel.background" = "#${palette.base00}";

    #   "panel.dropBackground" = "#${palette.base01}";

    #   "panelTitle.activeForeground" = "#${palette.base05}";
    #   "panelTitle.inactiveForeground" = "#${palette.base03}";

    #   "statusBar.background" = "#${palette.base0D}";
    #   "statusBar.foreground" = "#${palette.base07}";

    #   "statusBar.debuggingBackground" = "#${palette.base09}";
    #   "statusBar.debuggingForeground" = "#${palette.base07}";

    #   "statusBar.noFolderBackground" = "#${palette.base0E}";
    #   "statusBar.noFolderForeground" = "#${palette.base07}";

    #   "statusBarItem.activeBackground" = "#${palette.base03}";
    #   "statusBarItem.hoverBackground" = "#${palette.base02}";
    #   "statusBarItem.prominentForeground" = "#${palette.base07}";
    #   "statusBarItem.prominentBackground" = "#${palette.base0E}";
    #   "statusBarItem.prominentHoverBackground" = "#${palette.base08}";
    #   "statusBarItem.remoteBackground" = "#${palette.base0B}";
    #   "statusBarItem.remoteForeground" = "#${palette.base07}";
    #   "statusBarItem.errorBackground" = "#${palette.base08}";
    #   "statusBarItem.errorForeground" = "#${palette.base07}";

    #   "titleBar.activeBackground" = "#${palette.base00}";
    #   "titleBar.activeForeground" = "#${palette.base05}";
    #   "titleBar.inactiveBackground" = "#${palette.base01}";
    #   "titleBar.inactiveForeground" = "#${palette.base03}";

    #   "menubar.selectionForeground" = "#${palette.base05}";
    #   "menubar.selectionBackground" = "#${palette.base01}";

    #   "menu.foreground" = "#${palette.base05}";
    #   "menu.background" = "#${palette.base01}";
    #   "menu.selectionForeground" = "#${palette.base05}";
    #   "menu.selectionBackground" = "#${palette.base02}";

    #   "menu.separatorBackground" = "#${palette.base07}";

    #   "notificationCenterHeader.foreground" = "#${palette.base05}";
    #   "notificationCenterHeader.background" = "#${palette.base01}";

    #   "notifications.foreground" = "#${palette.base05}";
    #   "notifications.background" = "#${palette.base02}";

    #   "notificationLink.foreground" = "#${palette.base0D}";
    #   "notificationsErrorIcon.foreground" = "#${palette.base08}";
    #   "notificationsWarningIcon.foreground" = "#${palette.base0A}";
    #   "notificationsInfoIcon.foreground" = "#${palette.base0D}";

    #   "notification.background" = "#${palette.base02}";
    #   "notification.foreground" = "#${palette.base05}";
    #   "notification.buttonBackground" = "#${palette.base0D}";
    #   "notification.buttonHoverBackground" = "#${palette.base02}";
    #   "notification.buttonForeground" = "#${palette.base07}";
    #   "notification.infoBackground" = "#${palette.base0C}";
    #   "notification.infoForeground" = "#${palette.base07}";
    #   "notification.warningBackground" = "#${palette.base0A}";
    #   "notification.warningForeground" = "#${palette.base07}";
    #   "notification.errorBackground" = "#${palette.base08}";
    #   "notification.errorForeground" = "#${palette.base07}";

    #   "extensionButton.prominentBackground" = "#${palette.base0B}";
    #   "extensionButton.prominentForeground" = "#${palette.base07}";
    #   "extensionButton.prominentHoverBackground" = "#${palette.base02}";
    #   "extensionBadge.remoteBackground" = "#${palette.base09}";
    #   "extensionBadge.remoteForeground" = "#${palette.base07}";

    #   "pickerGroup.foreground" = "#${palette.base03}";
    #   "quickInput.background" = "#${palette.base01}";
    #   "quickInput.foreground" = "#${palette.base05}";

    #   "terminal.background" = "#${palette.base00}";
    #   "terminal.foreground" = "#${palette.base05}";
    #   "terminal.ansiBlack" = "#${palette.base00}";
    #   "terminal.ansiRed" = "#${palette.base08}";
    #   "terminal.ansiGreen" = "#${palette.base0B}";
    #   "terminal.ansiYellow" = "#${palette.base0A}";
    #   "terminal.ansiBlue" = "#${palette.base0D}";
    #   "terminal.ansiMagenta" = "#${palette.base0E}";
    #   "terminal.ansiCyan" = "#${palette.base0C}";
    #   "terminal.ansiWhite" = "#${palette.base05}";
    #   "terminal.ansiBrightBlack" = "#${palette.base03}";
    #   "terminal.ansiBrightRed" = "#${palette.base08}";
    #   "terminal.ansiBrightGreen" = "#${palette.base0B}";
    #   "terminal.ansiBrightYellow" = "#${palette.base0A}";
    #   "terminal.ansiBrightBlue" = "#${palette.base0D}";
    #   "terminal.ansiBrightMagenta" = "#${palette.base0E}";
    #   "terminal.ansiBrightCyan" = "#${palette.base0C}";
    #   "terminal.ansiBrightWhite" = "#${palette.base07}";

    #   "terminalCursor.foreground" = "#${palette.base05}";

    #   "debugToolBar.background" = "#${palette.base01}";

    #   "debugView.stateLabelForeground" = "#${palette.base07}";
    #   "debugView.stateLabelBackground" = "#${palette.base0D}";
    #   "debugView.valueChangedHighlight" = "#${palette.base0D}";
    #   "debugTokenExpression.name" = "#${palette.base0E}";
    #   "debugTokenExpression.value" = "#${palette.base05}";
    #   "debugTokenExpression.string" = "#${palette.base0B}";
    #   "debugTokenExpression.boolean" = "#${palette.base09}";
    #   "debugTokenExpression.number" = "#${palette.base09}";
    #   "debugTokenExpression.error" = "#${palette.base08}";

    #   "welcomePage.background" = "#${palette.base00}";
    #   "welcomePage.buttonBackground" = "#${palette.base01}";
    #   "welcomePage.buttonHoverBackground" = "#${palette.base02}";
    #   "walkThrough.embeddedEditorBackground" = "#${palette.base00}";

    #   "gitDecoration.addedResourceForeground" = "#${palette.base0B}";
    #   "gitDecoration.modifiedResourceForeground" = "#${palette.base0E}";
    #   "gitDecoration.stageModifiedResourceForeground" = "#${palette.base0E}";
    #   "gitDecoration.deletedResourceForeground" = "#${palette.base08}";
    #   "gitDecoration.stageDeletedResourceForeground" = "#${palette.base08}";
    #   "gitDecoration.untrackedResourceForeground" = "#${palette.base09}";
    #   "gitDecoration.ignoredResourceForeground" = "#${palette.base03}";
    #   "gitDecoration.conflictingResourceForeground" = "#${palette.base0A}";
    #   "gitDecoration.submoduleResourceForeground" = "#${palette.base0F}";

    #   "settings.headerForeground" = "#${palette.base05}";
    #   "settings.modifiedItemIndicator" = "#${palette.base0D}";

    #   "settings.modifiedItemForeground" = "#${palette.base0D}";

    #   "settings.dropdownBackground" = "#${palette.base01}";
    #   "settings.dropdownForeground" = "#${palette.base05}";

    #   "settings.checkboxBackground" = "#${palette.base01}";
    #   "settings.checkboxForeground" = "#${palette.base05}";

    #   "settings.textInputBackground" = "#${palette.base01}";
    #   "settings.textInputForeground" = "#${palette.base05}";

    #   "settings.numberInputBackground" = "#${palette.base01}";
    #   "settings.numberInputForeground" = "#${palette.base05}";

    #   "settings.focusedRowBackground" = "#${palette.base02}";

    #   "breadcrumb.foreground" = "#${palette.base05}";
    #   "breadcrumb.background" = "#${palette.base01}";
    #   "breadcrumb.focusForeground" = "#${palette.base06}";
    #   "breadcrumb.activeSelectionForeground" = "#${palette.base07}";
    #   "breadcrumbPicker.background" = "#${palette.base01}";

    #   "editor.snippetTabstopHighlightBackground" = "#${palette.base02}";

    #   "editor.snippetFinalTabstopHighlightBackground" = "#${palette.base03}";

    #   "symbolIcon.arrayForeground" = "#${palette.base05}";
    #   "symbolIcon.booleanForeground" = "#${palette.base09}";
    #   "symbolIcon.classForeground" = "#${palette.base0A}";
    #   "symbolIcon.colorForeground" = "#${palette.base05}";
    #   "symbolIcon.constantForeground" = "#${palette.base09}";
    #   "symbolIcon.constructorForeground" = "#${palette.base0D}";
    #   "symbolIcon.enumeratorForeground" = "#${palette.base09}";
    #   "symbolIcon.enumeratorMemberForeground" = "#${palette.base0D}";
    #   "symbolIcon.eventForeground" = "#${palette.base0A}";
    #   "symbolIcon.fieldForeground" = "#${palette.base08}";
    #   "symbolIcon.fileForeground" = "#${palette.base05}";
    #   "symbolIcon.folderForeground" = "#${palette.base05}";
    #   "symbolIcon.functionForeground" = "#${palette.base0D}";
    #   "symbolIcon.interfaceForeground" = "#${palette.base0D}";
    #   "symbolIcon.keyForeground" = "#${palette.base0B}";
    #   "symbolIcon.keywordForeground" = "#${palette.base0E}";
    #   "symbolIcon.methodForeground" = "#${palette.base0D}";
    #   "symbolIcon.moduleForeground" = "#${palette.base05}";
    #   "symbolIcon.namespaceForeground" = "#${palette.base05}";
    #   "symbolIcon.nullForeground" = "#${palette.base0F}";
    #   "symbolIcon.numberForeground" = "#${palette.base09}";
    #   "symbolIcon.objectForeground" = "#${palette.base0A}";
    #   "symbolIcon.operatorForeground" = "#${palette.base0A}";
    #   "symbolIcon.packageForeground" = "#${palette.base0A}";
    #   "symbolIcon.propertyForeground" = "#${palette.base05}";
    #   "symbolIcon.referenceForeground" = "#${palette.base08}";
    #   "symbolIcon.snippetForeground" = "#${palette.base05}";
    #   "symbolIcon.stringForeground" = "#${palette.base0B}";
    #   "symbolIcon.structForeground" = "#${palette.base0A}";
    #   "symbolIcon.textForeground" = "#${palette.base05}";
    #   "symbolIcon.typeParameterForeground" = "#${palette.base0E}";
    #   "symbolIcon.unitForeground" = "#${palette.base05}";
    #   "symbolIcon.variableForeground" = "#${palette.base08}";

    #   "debugIcon.breakpointForeground" = "#${palette.base08}";
    #   "debugIcon.breakpointDisabledForeground" = "#${palette.base04}";
    #   "debugIcon.breakpointUnverifiedForeground" = "#${palette.base02}";
    #   "debugIcon.breakpointCurrentStackframeForeground" = "#${palette.base0A}";
    #   "debugIcon.breakpointStackframeForeground" = "#${palette.base0F}";
    #   "debugIcon.startForeground" = "#${palette.base0B}";
    #   "debugIcon.pauseForeground" = "#${palette.base0D}";
    #   "debugIcon.stopForeground" = "#${palette.base08}";
    #   "debugIcon.disconnectForeground" = "#${palette.base08}";
    #   "debugIcon.restartForeground" = "#${palette.base0B}";
    #   "debugIcon.stepOverForeground" = "#${palette.base0D}";
    #   "debugIcon.stepIntoForeground" = "#${palette.base0C}";
    #   "debugIcon.stepOutForeground" = "#${palette.base0E}";
    #   "debugIcon.continueForeground" = "#${palette.base0B}";
    #   "debugIcon.stepBackForeground" = "#${palette.base0F}";
    #   "debugConsole.infoForeground" = "#${palette.base05}";
    #   "debugConsole.warningForeground" = "#${palette.base0A}";
    #   "debugConsole.errorForeground" = "#${palette.base08}";
    #   "debugConsole.sourceForeground" = "#${palette.base05}";
    #   "debugConsoleInputIcon.foreground" = "#${palette.base05}";

    #   "notebook.rowHoverBackground" = "#${palette.base01}";

    #   "charts.foreground" = "#${palette.base05}";
    #   "charts.lines" = "#${palette.base05}";
    #   "charts.red" = "#${palette.base08}";
    #   "charts.blue" = "#${palette.base0D}";
    #   "charts.yellow" = "#${palette.base0A}";
    #   "charts.orange" = "#${palette.base09}";
    #   "charts.green" = "#${palette.base0B}";
    #   "charts.purple" = "#${palette.base0E}";
    # };
  };
}
