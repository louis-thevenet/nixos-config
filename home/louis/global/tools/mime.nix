{ config, lib, pkgs, ... }:
let
  cfg = config.home-config.desktop.wayland;
in
{
  xdg = lib.mkIf cfg.enable {
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications =
        let
          browser = "firefox.desktop";
          editor = "helix.desktop";
          image = "qimgv.desktop";
          pdf = "okular.desktop";
          files = "yazi.desktop";
        in
        {
          "text/html" = browser;
          "image/*" = image;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/about" = browser;
          "application/pdf" = pdf;
          "text/plain" = editor;
          "text/*" = editor;
          "inode/directory" = files;
          "x-scheme-handler/file" = files;
        };
    };
    dataFile."applications/yazi.desktop" = {
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Yazi
        Comment=Terminal file manager
        Exec=${lib.getExe pkgs.kitty} ${lib.getExe pkgs.yazi} %U
        Terminal=true
        MimeType=inode/directory;
        Categories=FileManager;System;FileTools;
      '';
    };
  };

  home.sessionVariables = lib.mkIf cfg.enable {
    FILEMANAGER = "yazi";
  };
}
