{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation rec {
  pname = "isabelle-llvm";
  version = "2023";

  src = fetchFromGitHub {
    owner = "lammich";
    repo = "isabelle_llvm";
    rev = version;
    sha256 = "sha256-eTNlxuPogbfhHtyFHagod98h6qdg0f8XGiwVi87gpv4=";
  };

  installPhase = ''
    mkdir -p $out
    ln -s $src $out/lib
  '';
}
