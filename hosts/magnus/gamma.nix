{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    umu-launcher
    p7zip
    unrar
    gtk4
    libadwaita
    gobject-introspection
    (python3.withPackages (pythonPackages: [ pythonPackages.pygobject3 ]))
    vulkan-tools
  ];

  # Proton/DXVK requires the 32-bit Vulkan/OpenGL driver stack as well.
  hardware.graphics.enable32Bit = true;

  programs.gamemode.enable = true;
  users.users.louis.extraGroups = [ "gamemode" ];

  # Let the native GAMMA launcher load GTK4/libadwaita through PyGObject.
  environment.sessionVariables.GI_TYPELIB_PATH = pkgs.lib.makeSearchPath "lib/girepository-1.0" [
    pkgs.gobject-introspection
    pkgs.glib
    pkgs.gdk-pixbuf
    pkgs.graphene
    pkgs.harfbuzz
    pkgs.pango.out
    pkgs.gtk4
    pkgs.libadwaita
  ];
  environment.sessionVariables.UNRAR_LIB_PATH = "${pkgs.unrar}/lib/libunrar.so";
}
