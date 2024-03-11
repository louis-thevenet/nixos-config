{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  cairo,
  gobject-introspection,
  pango,
}:
rustPlatform.buildRustPackage rec {
  pname = "rofi-ollama";
  version = "31b6b97b708946e1448b80e844db4183ffb5d6e8";

  src = fetchFromGitHub {
    owner = "louis-thevenet";
    repo = pname;
    rev = version;
    hash = "sha256-mxkH0DjgOPdE4PvhmmFGcLZfCQ2GtY7yBFMXfa619zA=";
  };

  cargoHash = "sha256-raWEnmBhgQRx0mit//2F82rTN5VQ8/verxYDwLgEmLU=";
  RUSTFLAGS = "--cfg rofi_next";
  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    cairo
  ];

  buildInputs = [pango openssl];
  meta = {
    description = "A rofi plugin to fetch and run available ollama models";
    homepage = "https://github.com/louis-thevenet/rofi-ollama";
    license = lib.licenses.unlicense;
    maintainers = [];
  };
}
