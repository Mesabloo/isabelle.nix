{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "isabelle-llvm";
  version = "2022";

  src = fetchFromGitHub {
    owner = "lammich";
    repo = "isabelle_llvm";
    rev = "6be37a9c3cae74a1134dbef2979e312abb5f7f42";
    sha256 = "07q39d42gncdaqg618m2scpcb1gaiygq6ssldbq8i2dbhb76g9ll";
  };

  installPhase = ''
    mkdir -p $out
    ln -s $src $out/lib
  '';
}
