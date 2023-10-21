# For Isabelle, we need to enable `--enable-intinf-as-int' otherwise it won't build
# Isabelle/Pure.
{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, gmp
, libffi
}:

stdenv.mkDerivation rec {
  pname = "polyml";
  version = "219e0a248f705b770d45699755d00f05b82a9391";

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure.ac --replace stdc++ c++
  '';

  buildInputs = [ libffi gmp ];

  nativeBuildInputs = lib.optional stdenv.isDarwin autoreconfHook;

  configureFlags = [
    "--enable-shared"
    "--with-system-libffi"
    "--with-gmp"
    # this is needed for isabelle
    "--enable-intinf-as-int"
  ];

  src = fetchFromGitHub {
    owner = "polyml";
    repo = "polyml";
    rev = version;
    sha256 = "sha256-HtT3MGtHrqVhynmx73L7NC12AW9N7gkkOi7MKbF4k6Y=";
  };

  meta = with lib; {
    description = "Standard ML compiler and interpreter";
    longDescription = ''
      Poly/ML is a full implementation of Standard ML.
    '';
    homepage = "https://www.polyml.org/";
    license = licenses.lgpl21;
    platforms = with platforms; (linux ++ darwin);
    maintainers = with maintainers; [ maggesi kovirobi ];
  };
}
