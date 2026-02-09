_: {
  programs.dconf.enable = true;
  services = {
    printing.enable = true;
    pulseaudio.enable = false;
    gnome.gnome-keyring.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      wireplumber.enable = true;
      extraConfig.pipewire."bluez-monitor" = {
        "properties" = {
          "bluez5.hfphfp-backend" = "native";
          "bluez5.enable-msbc" = true;
          "bluez5.enable-sbc-xq" = true;
        };
      };
    };
  };
}
