_: {
  xdg = {
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
        };
    };
  };
}
