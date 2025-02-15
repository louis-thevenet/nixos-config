_:
{
  virtualisation.libvirtd.enable = true;
  users.users.louis.extraGroups = [ "libvirtd" ];
}
