{ lib
, stdenv
, fetchurl
, gnumake
, gcc
}:

stdenv.mkDerivation rec {
  pname = "riverbsp";
  version = "1.0.0";
  src = fetchurl {
    url = "https://github.com/jonbkei/${pname}/archive/refs/heads/master.tar.gz";
    hash = "sha256-G6MhlNYFjSjq+ZY92wktMPJGs/swLokx/NNyiThWaKQ=";
  };

  nativeBuildInputs = [ gnumake gcc ];

  buildPhase = ''
    make riverbsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/riverbsp $out/bin/riverbsp
  '';


  meta = with lib; {
    platforms = platforms.all;
  };
}
