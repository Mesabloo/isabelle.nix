{ stdenv, fetchhg, mercurial }:

stdenv.mkDerivation rec {
  pname = "isabelle-afp";
  version = "2022";

  src = fetchhg {
    url = "https://foss.heptapod.net/isa-afp/afp-${version}";
    rev = "2458cc9f2178445ab58d5403f68df2efb98b1c7d";
    sha256 = "00s2d939xn0ix1nlhdb5xsjrj7z0mw3pbr6gbdxg0qavnn2l2anc";
  };

  installPhase = ''
    mkdir -p $out/lib
    
    mv thys etc tools/lib/afp_build web $out/lib/
    rm $out/lib/etc/build.props 
  '';
}
