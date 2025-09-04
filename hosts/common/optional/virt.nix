_: {
  virtualisation = {
    libvirtd.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
    };
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
  };
  users.users.louis.extraGroups = [ "libvirtd" ];
}
