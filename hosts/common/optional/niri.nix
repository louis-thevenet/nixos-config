_: {
  # Niri config in HM config
  programs.xwayland.enable = true;

  # Essential environment variables for EGL/Wayland integration
  environment.sessionVariables = {
    EGL_PLATFORM = "wayland";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
  };
}
