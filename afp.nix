{ stdenv, fetchhg, mercurial, lib }:

stdenv.mkDerivation rec {
  pname = "isabelle-afp";
  version = "2023";

  src = fetchhg {
    url = "https://foss.heptapod.net/isa-afp/afp-${version}";
    rev = "Isabelle${version}";
    sha256 = "sha256-P57t8SCVy0Y7f5J13mmF+rs1XZd9Fv6SCiNrrEEJxt0=";
  };

  installPhase = ''
    mkdir -p $out/lib
    
    mv thys etc tools/lib/afp_build web $out/lib/
    rm $out/lib/etc/build.props 
  '';
}
