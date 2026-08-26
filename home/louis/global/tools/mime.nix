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
          files = "org.kde.dolphin.desktop";
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
  };

  home.sessionVariables = lib.mkIf cfg.enable {
    FILEMANAGER = "dolphin";
  };

  home.packages = lib.mkIf cfg.enable [ pkgs.kdePackages.dolphin ];

}
