{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  perl,
}:
rustPlatform.buildRustPackage rec {
  pname = "smd";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "guilhermeprokisch";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9mfyYSrpuhq373QP6qOczuIKqi3j/AQNzNhJMXdHsNA";
  };

  cargoHash = "sha256-OefQpMUiWLHQvvV0uCDAEl92XXHFS1RKvtR9FaFuRv0=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [
    openssl
  ];

  postInstall = ''
  '';

  meta = {
    description = "Minimalistic Markdown renderer for the terminal with syntax highlighting, emoji support, and image rendering";
    homepage = "https://github.com/guilhermeprokisch/smd";
    license = lib.licenses.mit;
    mainProgram = "smd";
    maintainers = [];
  };
}
