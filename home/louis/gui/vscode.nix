{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
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
        github.copilot
        github.copilot-chat
        redhat.java
        vscjava.vscode-gradle
        vscjava.vscode-java-debug
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
    userSettings.editor.fontFamily = config.fontProfiles.monospace.family;

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

    # userSettings.workbench.colorCustomizations = let
    #   inherit (config.colorscheme) colors;
    # in {
    #   "foreground" = "#${colors.base05}";
    #   "widget.shadow" = "#${colors.base00}";
    #   "selection.background" = "#${colors.base0D}";
    #   "descriptionForeground" = "#${colors.base03}";
    #   "errorForeground" = "#${colors.base08}";
    #   "icon.foreground" = "#${colors.base04}";

    #   "textBlockQuote.background" = "#${colors.base01}";
    #   "textBlockQuote.border" = "#${colors.base0D}";
    #   "textCodeBlock.background" = "#${colors.base00}";
    #   "textLink.activeForeground" = "#${colors.base0C}";
    #   "textLink.foreground" = "#${colors.base0D}";
    #   "textPreformat.foreground" = "#${colors.base0D}";
    #   "textSeparator.foreground" = "#f0f";

    #   "button.background" = "#${colors.base01}";
    #   "button.foreground" = "#${colors.base07}";
    #   "button.hoverBackground" = "#${colors.base04}";
    #   "button.secondaryForeground" = "#${colors.base07}";
    #   "button.secondaryBackground" = "#${colors.base0E}";
    #   "button.secondaryHoverBackground" = "#${colors.base04}";
    #   "checkbox.background" = "#${colors.base00}";
    #   "checkbox.foreground" = "#${colors.base05}";

    #   "dropdown.background" = "#${colors.base00}";
    #   "dropdown.listBackground" = "#${colors.base00}";

    #   "dropdown.foreground" = "#${colors.base05}";

    #   "input.background" = "#${colors.base00}";

    #   "input.foreground" = "#${colors.base05}";
    #   "input.placeholderForeground" = "#${colors.base03}";
    #   "inputOption.activeBackground" = "#${colors.base02}";
    #   "inputOption.activeBorder" = "#${colors.base09}";
    #   "inputOption.activeForeground" = "#${colors.base05}";
    #   "inputValidation.errorBackground" = "#${colors.base08}";
    #   "inputValidation.errorForeground" = "#${colors.base05}";
    #   "inputValidation.errorBorder" = "#${colors.base08}";
    #   "inputValidation.infoBackground" = "#${colors.base0D}";
    #   "inputValidation.infoForeground" = "#${colors.base05}";
    #   "inputValidation.infoBorder" = "#${colors.base0D}";
    #   "inputValidation.warningBackground" = "#${colors.base0A}";
    #   "inputValidation.warningForeground" = "#${colors.base05}";
    #   "inputValidation.warningBorder" = "#${colors.base0A}";

    #   "scrollbar.shadow" = "#${colors.base01}";
    #   "scrollbarSlider.activeBackground" = "#${colors.base04}";
    #   "scrollbarSlider.background" = "#${colors.base02}";
    #   "scrollbarSlider.hoverBackground" = "#${colors.base03}";

    #   "badge.background" = "#${colors.base00}";
    #   "badge.foreground" = "#${colors.base05}";

    #   "progressBar.background" = "#${colors.base03}";

    #   "list.activeSelectionBackground" = "#${colors.base02}";
    #   "list.activeSelectionForeground" = "#${colors.base05}";
    #   "list.dropBackground" = "#${colors.base07}";
    #   "list.focusBackground" = "#${colors.base02}";
    #   "list.focusForeground" = "#${colors.base05}";
    #   "list.highlightForeground" = "#${colors.base07}";
    #   "list.hoverBackground" = "#${colors.base03}";
    #   "list.hoverForeground" = "#${colors.base05}";
    #   "list.inactiveSelectionBackground" = "#${colors.base02}";
    #   "list.inactiveSelectionForeground" = "#${colors.base05}";
    #   "list.inactiveFocusBackground" = "#${colors.base02}";
    #   "list.invalidItemForeground" = "#${colors.base08}";
    #   "list.errorForeground" = "#${colors.base08}";
    #   "list.warningForeground" = "#${colors.base0A}";
    #   "listFilterWidget.background" = "#${colors.base00}";

    #   "listFilterWidget.noMatchesOutline" = "#${colors.base08}";
    #   "list.filterMatchBackground" = "#${colors.base02}";

    #   "tree.indentGuidesStroke" = "#${colors.base05}";

    #   "activityBar.background" = "#${colors.base00}";
    #   "activityBar.dropBackground" = "#${colors.base07}";

    #   "activityBar.foreground" = "#${colors.base05}";
    #   "activityBar.inactiveForeground" = "#${colors.base03}";

    #   "activityBarBadge.background" = "#${colors.base0D}";
    #   "activityBarBadge.foreground" = "#${colors.base07}";

    #   "activityBar.activeBackground" = "#${colors.base02}";

    #   "sideBar.background" = "#${colors.base01}";
    #   "sideBar.foreground" = "#${colors.base05}";

    #   "sideBar.dropBackground" = "#${colors.base02}";
    #   "sideBarTitle.foreground" = "#${colors.base05}";
    #   "sideBarSectionHeader.background" = "#${colors.base03}";
    #   "sideBarSectionHeader.foreground" = "#${colors.base05}";

    #   "minimap.findMatchHighlight" = "#${colors.base0A}";
    #   "minimap.selectionHighlight" = "#${colors.base02}";
    #   "minimap.errorHighlight" = "#${colors.base08}";
    #   "minimap.warningHighlight" = "#${colors.base0A}";
    #   "minimap.background" = "#${colors.base00}";

    #   "minimapGutter.addedBackground" = "#${colors.base0B}";
    #   "minimapGutter.modifiedBackground" = "#${colors.base0E}";
    #   "minimapGutter.deletedBackground" = "#${colors.base08}";

    #   "editorGroup.background" = "#${colors.base00}";

    #   "editorGroup.dropBackground" = "#${colors.base02}";
    #   "editorGroupHeader.noTabsBackground" = "#${colors.base01}";
    #   "editorGroupHeader.tabsBackground" = "#${colors.base01}";

    #   "editorGroup.emptyBackground" = "#${colors.base00}";

    #   "tab.activeBackground" = "#${colors.base00}";
    #   "tab.unfocusedActiveBackground" = "#${colors.base00}";
    #   "tab.activeForeground" = "#${colors.base05}";

    #   "tab.inactiveBackground" = "#${colors.base01}";

    #   "tab.inactiveForeground" = "#${colors.base03}";
    #   "tab.unfocusedActiveForeground" = "#${colors.base04}";
    #   "tab.unfocusedInactiveForeground" = "#${colors.base03}";
    #   "tab.hoverBackground" = "#${colors.base02}";

    #   "tab.unfocusedHoverBackground" = "#${colors.base02}";

    #   "tab.activeModifiedBorder" = "#${colors.base0D}";
    #   "tab.inactiveModifiedBorder" = "#${colors.base0D}";
    #   "tab.unfocusedActiveModifiedBorder" = "#${colors.base0D}";
    #   "tab.unfocusedInactiveModifiedBorder" = "#${colors.base0D}";
    #   "editorPane.background" = "#${colors.base00}";

    #   "editor.background" = "#${colors.base00}";
    #   "editor.foreground" = "#${colors.base05}";
    #   "editorLineNumber.foreground" = "#${colors.base03}";
    #   "editorLineNumber.activeForeground" = "#${colors.base04}";

    #   "editorCursor.foreground" = "#${colors.base05}";
    #   "editor.selectionBackground" = "#${colors.base05}";
    #   "editor.selectionForeground" = "#${colors.base00}";

    #   "editor.inactiveSelectionBackground" = "#${colors.base02}";
    #   "editor.selectionHighlightBackground" = "#${colors.base01}";

    #   "editor.wordHighlightBackground" = "#${colors.base02}";

    #   "editor.wordHighlightStrongBackground" = "#${colors.base03}";

    #   "editor.findMatchBackground" = "#${colors.base0A}";
    #   "editor.findMatchHighlightBackground" = "#${colors.base09}";
    #   "editor.findRangeHighlightBackground" = "#${colors.base01}";

    #   "editor.hoverHighlightBackground" = "#${colors.base02}";
    #   "editor.lineHighlightBackground" = "#${colors.base01}";

    #   "editorLink.activeForeground" = "#${colors.base0D}";
    #   "editor.rangeHighlightBackground" = "#${colors.base01}";

    #   "editorWhitespace.foreground" = "#${colors.base03}";
    #   "editorIndentGuide.background" = "#${colors.base03}";
    #   "editorIndentGuide.activeBackground" = "#${colors.base04}";
    #   "editorRuler.foreground" = "#${colors.base03}";

    #   "editorCodeLens.foreground" = "#${colors.base02}";

    #   "editorLightBulb.foreground" = "#${colors.base0A}";
    #   "editorLightBulbAutoFix.foreground" = "#${colors.base0D}";
    #   "editorBracketMatch.background" = "#${colors.base02}";

    #   "editorOverviewRuler.findMatchForeground" = "#${colors.base0A}";
    #   "editorOverviewRuler.rangeHighlightForeground" = "#${colors.base03}";
    #   "editorOverviewRuler.selectionHighlightForeground" = "#${colors.base02}";
    #   "editorOverviewRuler.wordHighlightForeground" = "#${colors.base07}";
    #   "editorOverviewRuler.wordHighlightStrongForeground" = "#${colors.base0D}";
    #   "editorOverviewRuler.modifiedForeground" = "#${colors.base0E}";
    #   "editorOverviewRuler.addedForeground" = "#${colors.base0B}";
    #   "editorOverviewRuler.deletedForeground" = "#${colors.base08}";
    #   "editorOverviewRuler.errorForeground" = "#${colors.base08}";
    #   "editorOverviewRuler.warningForeground" = "#${colors.base0A}";
    #   "editorOverviewRuler.infoForeground" = "#${colors.base0C}";
    #   "editorOverviewRuler.bracketMatchForeground" = "#${colors.base06}";

    #   "editorError.foreground" = "#${colors.base08}";

    #   "editorWarning.foreground" = "#${colors.base0A}";

    #   "editorInfo.foreground" = "#${colors.base0C}";

    #   "editorHint.foreground" = "#${colors.base0D}";

    #   "problemsErrorIcon.foreground" = "#${colors.base08}";
    #   "problemsWarningIcon.foreground" = "#${colors.base0A}";
    #   "problemsInfoIcon.foreground" = "#${colors.base0C}";

    #   "editorGutter.addedBackground" = "#${colors.base0B}";
    #   "editorGutter.background" = "#${colors.base00}";
    #   "editorGutter.deletedBackground" = "#${colors.base08}";
    #   "editorGutter.modifiedBackground" = "#${colors.base0E}";
    #   "editorGutter.commentRangeForeground" = "#${colors.base04}";
    #   "editorGutter.foldingControlForeground" = "#${colors.base05}";

    #   "diffEditor.insertedTextBackground" = "#${colors.base0B}";

    #   "diffEditor.removedTextBackground" = "#${colors.base08}";

    #   "diffEditor.diagonalFill" = "#${colors.base02}";

    #   "editorWidget.foreground" = "#${colors.base05}";
    #   "editorWidget.background" = "#${colors.base00}";

    #   "editorSuggestWidget.background" = "#${colors.base01}";

    #   "editorSuggestWidget.foreground" = "#${colors.base05}";
    #   "editorSuggestWidget.highlightForeground" = "#${colors.base0D}";
    #   "editorSuggestWidget.selectedBackground" = "#${colors.base02}";
    #   "editorHoverWidget.foreground" = "#${colors.base05}";
    #   "editorHoverWidget.background" = "#${colors.base00}";

    #   "debugExceptionWidget.background" = "#${colors.base01}";

    #   "editorMarkerNavigation.background" = "#${colors.base01}";
    #   "editorMarkerNavigationError.background" = "#${colors.base08}";
    #   "editorMarkerNavigationWarning.background" = "#${colors.base0A}";
    #   "editorMarkerNavigationInfo.background" = "#${colors.base0D}";

    #   "peekViewEditor.background" = "#${colors.base01}";
    #   "peekViewEditorGutter.background" = "#${colors.base01}";
    #   "peekViewEditor.matchHighlightBackground" = "#${colors.base09}";

    #   "peekViewResult.background" = "#${colors.base00}";
    #   "peekViewResult.fileForeground" = "#${colors.base05}";
    #   "peekViewResult.lineForeground" = "#${colors.base03}";
    #   "peekViewResult.matchHighlightBackground" = "#${colors.base09}";
    #   "peekViewResult.selectionBackground" = "#${colors.base02}";
    #   "peekViewResult.selectionForeground" = "#${colors.base05}";
    #   "peekViewTitle.background" = "#${colors.base02}";
    #   "peekViewTitleDescription.foreground" = "#${colors.base03}";
    #   "peekViewTitleLabel.foreground" = "#${colors.base05}";

    #   "merge.currentContentBackground" = "#${colors.base0D}";
    #   "merge.currentHeaderBackground" = "#${colors.base0D}";
    #   "merge.incomingContentBackground" = "#${colors.base0B}";
    #   "merge.incomingHeaderBackground" = "#${colors.base0B}";

    #   "editorOverviewRuler.currentContentForeground" = "#${colors.base0D}";
    #   "editorOverviewRuler.incomingContentForeground" = "#${colors.base0B}";
    #   "editorOverviewRuler.commonContentForeground" = "#${colors.base0F}";

    #   "panel.background" = "#${colors.base00}";

    #   "panel.dropBackground" = "#${colors.base01}";

    #   "panelTitle.activeForeground" = "#${colors.base05}";
    #   "panelTitle.inactiveForeground" = "#${colors.base03}";

    #   "statusBar.background" = "#${colors.base0D}";
    #   "statusBar.foreground" = "#${colors.base07}";

    #   "statusBar.debuggingBackground" = "#${colors.base09}";
    #   "statusBar.debuggingForeground" = "#${colors.base07}";

    #   "statusBar.noFolderBackground" = "#${colors.base0E}";
    #   "statusBar.noFolderForeground" = "#${colors.base07}";

    #   "statusBarItem.activeBackground" = "#${colors.base03}";
    #   "statusBarItem.hoverBackground" = "#${colors.base02}";
    #   "statusBarItem.prominentForeground" = "#${colors.base07}";
    #   "statusBarItem.prominentBackground" = "#${colors.base0E}";
    #   "statusBarItem.prominentHoverBackground" = "#${colors.base08}";
    #   "statusBarItem.remoteBackground" = "#${colors.base0B}";
    #   "statusBarItem.remoteForeground" = "#${colors.base07}";
    #   "statusBarItem.errorBackground" = "#${colors.base08}";
    #   "statusBarItem.errorForeground" = "#${colors.base07}";

    #   "titleBar.activeBackground" = "#${colors.base00}";
    #   "titleBar.activeForeground" = "#${colors.base05}";
    #   "titleBar.inactiveBackground" = "#${colors.base01}";
    #   "titleBar.inactiveForeground" = "#${colors.base03}";

    #   "menubar.selectionForeground" = "#${colors.base05}";
    #   "menubar.selectionBackground" = "#${colors.base01}";

    #   "menu.foreground" = "#${colors.base05}";
    #   "menu.background" = "#${colors.base01}";
    #   "menu.selectionForeground" = "#${colors.base05}";
    #   "menu.selectionBackground" = "#${colors.base02}";

    #   "menu.separatorBackground" = "#${colors.base07}";

    #   "notificationCenterHeader.foreground" = "#${colors.base05}";
    #   "notificationCenterHeader.background" = "#${colors.base01}";

    #   "notifications.foreground" = "#${colors.base05}";
    #   "notifications.background" = "#${colors.base02}";

    #   "notificationLink.foreground" = "#${colors.base0D}";
    #   "notificationsErrorIcon.foreground" = "#${colors.base08}";
    #   "notificationsWarningIcon.foreground" = "#${colors.base0A}";
    #   "notificationsInfoIcon.foreground" = "#${colors.base0D}";

    #   "notification.background" = "#${colors.base02}";
    #   "notification.foreground" = "#${colors.base05}";
    #   "notification.buttonBackground" = "#${colors.base0D}";
    #   "notification.buttonHoverBackground" = "#${colors.base02}";
    #   "notification.buttonForeground" = "#${colors.base07}";
    #   "notification.infoBackground" = "#${colors.base0C}";
    #   "notification.infoForeground" = "#${colors.base07}";
    #   "notification.warningBackground" = "#${colors.base0A}";
    #   "notification.warningForeground" = "#${colors.base07}";
    #   "notification.errorBackground" = "#${colors.base08}";
    #   "notification.errorForeground" = "#${colors.base07}";

    #   "extensionButton.prominentBackground" = "#${colors.base0B}";
    #   "extensionButton.prominentForeground" = "#${colors.base07}";
    #   "extensionButton.prominentHoverBackground" = "#${colors.base02}";
    #   "extensionBadge.remoteBackground" = "#${colors.base09}";
    #   "extensionBadge.remoteForeground" = "#${colors.base07}";

    #   "pickerGroup.foreground" = "#${colors.base03}";
    #   "quickInput.background" = "#${colors.base01}";
    #   "quickInput.foreground" = "#${colors.base05}";

    #   "terminal.background" = "#${colors.base00}";
    #   "terminal.foreground" = "#${colors.base05}";
    #   "terminal.ansiBlack" = "#${colors.base00}";
    #   "terminal.ansiRed" = "#${colors.base08}";
    #   "terminal.ansiGreen" = "#${colors.base0B}";
    #   "terminal.ansiYellow" = "#${colors.base0A}";
    #   "terminal.ansiBlue" = "#${colors.base0D}";
    #   "terminal.ansiMagenta" = "#${colors.base0E}";
    #   "terminal.ansiCyan" = "#${colors.base0C}";
    #   "terminal.ansiWhite" = "#${colors.base05}";
    #   "terminal.ansiBrightBlack" = "#${colors.base03}";
    #   "terminal.ansiBrightRed" = "#${colors.base08}";
    #   "terminal.ansiBrightGreen" = "#${colors.base0B}";
    #   "terminal.ansiBrightYellow" = "#${colors.base0A}";
    #   "terminal.ansiBrightBlue" = "#${colors.base0D}";
    #   "terminal.ansiBrightMagenta" = "#${colors.base0E}";
    #   "terminal.ansiBrightCyan" = "#${colors.base0C}";
    #   "terminal.ansiBrightWhite" = "#${colors.base07}";

    #   "terminalCursor.foreground" = "#${colors.base05}";

    #   "debugToolBar.background" = "#${colors.base01}";

    #   "debugView.stateLabelForeground" = "#${colors.base07}";
    #   "debugView.stateLabelBackground" = "#${colors.base0D}";
    #   "debugView.valueChangedHighlight" = "#${colors.base0D}";
    #   "debugTokenExpression.name" = "#${colors.base0E}";
    #   "debugTokenExpression.value" = "#${colors.base05}";
    #   "debugTokenExpression.string" = "#${colors.base0B}";
    #   "debugTokenExpression.boolean" = "#${colors.base09}";
    #   "debugTokenExpression.number" = "#${colors.base09}";
    #   "debugTokenExpression.error" = "#${colors.base08}";

    #   "welcomePage.background" = "#${colors.base00}";
    #   "welcomePage.buttonBackground" = "#${colors.base01}";
    #   "welcomePage.buttonHoverBackground" = "#${colors.base02}";
    #   "walkThrough.embeddedEditorBackground" = "#${colors.base00}";

    #   "gitDecoration.addedResourceForeground" = "#${colors.base0B}";
    #   "gitDecoration.modifiedResourceForeground" = "#${colors.base0E}";
    #   "gitDecoration.stageModifiedResourceForeground" = "#${colors.base0E}";
    #   "gitDecoration.deletedResourceForeground" = "#${colors.base08}";
    #   "gitDecoration.stageDeletedResourceForeground" = "#${colors.base08}";
    #   "gitDecoration.untrackedResourceForeground" = "#${colors.base09}";
    #   "gitDecoration.ignoredResourceForeground" = "#${colors.base03}";
    #   "gitDecoration.conflictingResourceForeground" = "#${colors.base0A}";
    #   "gitDecoration.submoduleResourceForeground" = "#${colors.base0F}";

    #   "settings.headerForeground" = "#${colors.base05}";
    #   "settings.modifiedItemIndicator" = "#${colors.base0D}";

    #   "settings.modifiedItemForeground" = "#${colors.base0D}";

    #   "settings.dropdownBackground" = "#${colors.base01}";
    #   "settings.dropdownForeground" = "#${colors.base05}";

    #   "settings.checkboxBackground" = "#${colors.base01}";
    #   "settings.checkboxForeground" = "#${colors.base05}";

    #   "settings.textInputBackground" = "#${colors.base01}";
    #   "settings.textInputForeground" = "#${colors.base05}";

    #   "settings.numberInputBackground" = "#${colors.base01}";
    #   "settings.numberInputForeground" = "#${colors.base05}";

    #   "settings.focusedRowBackground" = "#${colors.base02}";

    #   "breadcrumb.foreground" = "#${colors.base05}";
    #   "breadcrumb.background" = "#${colors.base01}";
    #   "breadcrumb.focusForeground" = "#${colors.base06}";
    #   "breadcrumb.activeSelectionForeground" = "#${colors.base07}";
    #   "breadcrumbPicker.background" = "#${colors.base01}";

    #   "editor.snippetTabstopHighlightBackground" = "#${colors.base02}";

    #   "editor.snippetFinalTabstopHighlightBackground" = "#${colors.base03}";

    #   "symbolIcon.arrayForeground" = "#${colors.base05}";
    #   "symbolIcon.booleanForeground" = "#${colors.base09}";
    #   "symbolIcon.classForeground" = "#${colors.base0A}";
    #   "symbolIcon.colorForeground" = "#${colors.base05}";
    #   "symbolIcon.constantForeground" = "#${colors.base09}";
    #   "symbolIcon.constructorForeground" = "#${colors.base0D}";
    #   "symbolIcon.enumeratorForeground" = "#${colors.base09}";
    #   "symbolIcon.enumeratorMemberForeground" = "#${colors.base0D}";
    #   "symbolIcon.eventForeground" = "#${colors.base0A}";
    #   "symbolIcon.fieldForeground" = "#${colors.base08}";
    #   "symbolIcon.fileForeground" = "#${colors.base05}";
    #   "symbolIcon.folderForeground" = "#${colors.base05}";
    #   "symbolIcon.functionForeground" = "#${colors.base0D}";
    #   "symbolIcon.interfaceForeground" = "#${colors.base0D}";
    #   "symbolIcon.keyForeground" = "#${colors.base0B}";
    #   "symbolIcon.keywordForeground" = "#${colors.base0E}";
    #   "symbolIcon.methodForeground" = "#${colors.base0D}";
    #   "symbolIcon.moduleForeground" = "#${colors.base05}";
    #   "symbolIcon.namespaceForeground" = "#${colors.base05}";
    #   "symbolIcon.nullForeground" = "#${colors.base0F}";
    #   "symbolIcon.numberForeground" = "#${colors.base09}";
    #   "symbolIcon.objectForeground" = "#${colors.base0A}";
    #   "symbolIcon.operatorForeground" = "#${colors.base0A}";
    #   "symbolIcon.packageForeground" = "#${colors.base0A}";
    #   "symbolIcon.propertyForeground" = "#${colors.base05}";
    #   "symbolIcon.referenceForeground" = "#${colors.base08}";
    #   "symbolIcon.snippetForeground" = "#${colors.base05}";
    #   "symbolIcon.stringForeground" = "#${colors.base0B}";
    #   "symbolIcon.structForeground" = "#${colors.base0A}";
    #   "symbolIcon.textForeground" = "#${colors.base05}";
    #   "symbolIcon.typeParameterForeground" = "#${colors.base0E}";
    #   "symbolIcon.unitForeground" = "#${colors.base05}";
    #   "symbolIcon.variableForeground" = "#${colors.base08}";

    #   "debugIcon.breakpointForeground" = "#${colors.base08}";
    #   "debugIcon.breakpointDisabledForeground" = "#${colors.base04}";
    #   "debugIcon.breakpointUnverifiedForeground" = "#${colors.base02}";
    #   "debugIcon.breakpointCurrentStackframeForeground" = "#${colors.base0A}";
    #   "debugIcon.breakpointStackframeForeground" = "#${colors.base0F}";
    #   "debugIcon.startForeground" = "#${colors.base0B}";
    #   "debugIcon.pauseForeground" = "#${colors.base0D}";
    #   "debugIcon.stopForeground" = "#${colors.base08}";
    #   "debugIcon.disconnectForeground" = "#${colors.base08}";
    #   "debugIcon.restartForeground" = "#${colors.base0B}";
    #   "debugIcon.stepOverForeground" = "#${colors.base0D}";
    #   "debugIcon.stepIntoForeground" = "#${colors.base0C}";
    #   "debugIcon.stepOutForeground" = "#${colors.base0E}";
    #   "debugIcon.continueForeground" = "#${colors.base0B}";
    #   "debugIcon.stepBackForeground" = "#${colors.base0F}";
    #   "debugConsole.infoForeground" = "#${colors.base05}";
    #   "debugConsole.warningForeground" = "#${colors.base0A}";
    #   "debugConsole.errorForeground" = "#${colors.base08}";
    #   "debugConsole.sourceForeground" = "#${colors.base05}";
    #   "debugConsoleInputIcon.foreground" = "#${colors.base05}";

    #   "notebook.rowHoverBackground" = "#${colors.base01}";

    #   "charts.foreground" = "#${colors.base05}";
    #   "charts.lines" = "#${colors.base05}";
    #   "charts.red" = "#${colors.base08}";
    #   "charts.blue" = "#${colors.base0D}";
    #   "charts.yellow" = "#${colors.base0A}";
    #   "charts.orange" = "#${colors.base09}";
    #   "charts.green" = "#${colors.base0B}";
    #   "charts.purple" = "#${colors.base0E}";
    # };
  };
}
