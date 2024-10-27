{ pkgs, ... }:
{
  xdg = {
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications =
        let
          browser = "Schizofox.desktop";
          editor = "code.desktop";
        in
        {
          "text/html" = browser;
          "image/*" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/about" = browser;
          "application/pdf" = "org.kde.okular.desktop";
          "text/plain" = editor;
          "text/*" = editor;
          "inode/directory" = "yazi.desktop";
        };
    };
  };
}
