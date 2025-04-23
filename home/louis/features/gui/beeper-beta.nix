{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
}:
appimageTools.wrapType2 rec {
  pname = "beepertexts";
  version = "4.0.551";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchurl {
    url = "https://beeper-desktop.download.beeper.com/builds/Beeper-${version}.AppImage";
    hash = "sha256-OLwLjgWFOiBS5RkEpvhH7hreri8EF+JRvKy+Kdre8gM=";
  };

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

      install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-warn 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
      cp -r ${contents}/usr/share/icons $out/share
    '';

  meta = with lib; {
    description = "Beeper Beta";
    license = licenses.unfree;
    maintainers = with maintainers; [ rycee ];
    mainProgram = pname;
  };
}
