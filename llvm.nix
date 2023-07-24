{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "isabelle-llvm";
  version = "2022";

  src = fetchFromGitHub {
    owner = "lammich";
    repo = "isabelle_llvm";
    rev = "7089263d2c3a01c3d01fa2711486773e38840762";
    sha256 = "1d5nl76prkyhjq0avnzrwkniks78rc76gnabk7fkdz6g4pzazrpy";
  };

  installPhase = ''
    mkdir -p $out
    ln -s $src $out/lib
  '';
}
