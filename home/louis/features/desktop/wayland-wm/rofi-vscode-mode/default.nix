{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  cairo,
  gobject-introspection,
  pango,
  sqlite,
}:
rustPlatform.buildRustPackage rec {
  pname = "rofi-vscode-mode";
  version = "31b6b97b708946e1448b80e844db4183ffb5d6e8";

  src = fetchFromGitHub {
    owner = "fuljo";
    repo = pname;
    rev = "v0.5.7";
    hash = "sha256-AAHkXBlPgGMVLI5m1CGmRA+TDDghaqaQsdlXdkOZ5MY=";
  };

  cargoHash = "sha256-cePtg8ko6ZddVpVfCbn2uco/5cqXKeqv5ak1WOKOIEg=";
  RUSTFLAGS = "--cfg rofi_next";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    pango
    sqlite
    gobject-introspection
    cairo
  ];

  postInstall = ''
    mkdir $out/lib/rofi
    mv $out/lib/librofi_vscode_mode.so $out/lib/rofi/
  '';

  meta = {
    description = "A rofi mode to fetch and open recent VSCode projects";
    homepage = "https://github.com/fuljo/rofi-vscode-mode";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
}
