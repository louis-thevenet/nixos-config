_: {
  virtualisation.libvirtd.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  users.users.louis.extraGroups = [ "libvirtd" ];
}
