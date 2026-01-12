{
  stdenv,
  fetchFromGitHub,
  python3Packages,
}:
let
  stickerpicker-tools = python3Packages.buildPythonPackage {
    pname = "maunium-stickerpicker-tools";
    version = "0-unstable-2025-06-29";

    src = fetchFromGitHub {
      owner = "maunium";
      repo = "stickerpicker";
      rev = "3366dbc5002046be058a71e7ed310811a122c081";
      sha256 = "sha256-P6MI+3SfQKpXyqGzZgsLBoZ2aOUbFxHbDhHbr6xJpXc=";
    };

    pyproject = true;
    build-system = with python3Packages; [ setuptools ];

    propagatedBuildInputs = with python3Packages; [
      aiohttp
      pillow
      telethon
      cryptg
      python-magic
    ];

    doCheck = false;
  };
in
stdenv.mkDerivation {
  pname = "maunium-stickerpicker";
  version = "0-unstable-2025-06-29";

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "stickerpicker";
    rev = "3366dbc5002046be058a71e7ed310811a122c081";
    sha256 = "sha256-P6MI+3SfQKpXyqGzZgsLBoZ2aOUbFxHbDhHbr6xJpXc=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r web $out/
  '';

  passthru = {
    tools = stickerpicker-tools;
  };
}
