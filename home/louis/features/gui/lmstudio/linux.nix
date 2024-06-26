{
  lib,
  appimageTools,
  fetchurl,
  version,
  pname,
  meta,
}: let
  src = fetchurl {
    url = "https://releases.lmstudio.ai/linux/${version}/beta/LM_Studio-${version}.AppImage";
    hash = "sha256-HoAVUU5Z5ueGMSybhT0OKV611v1yU5am0wy0GsCUmvk";
  };

  appimageContents = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit meta pname version src;

    extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ [pkgs.ocl-icd];

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp -r ${appimageContents}/usr/share/icons $out/share
      install -m 444 -D ${appimageContents}/lm-studio.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/lm-studio.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=lmstudio'
    '';
  }
