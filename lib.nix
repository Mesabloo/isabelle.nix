self: { system, pkgs, isabelle }:

let
  home = "$out";
  isa-home = "$out/.${isabelle.name}";
  isa = "${isabelle}/bin/isabelle";
  # isa = ''
  #   ${isabelle}/bin/isabelle env USER_HOME=${home} ISABELLE_HOME_USER=${isa-home} ISABELLE_HEAPS=${isa-home}/heaps \
  #     ISABELLE_OPAM_ROOT=${isa-home}/.opam ISABELLE_STACK_ROOT=${isa-home}/.stack ISABELLE_BROWSER_INFO=${isa-home}/browser_info \
  #     ISABELLE_COMPONENTS_BASE=${isa-home}/contrib \
  #     ${isabelle}/bin/isabelle'';
in
rec {
  # Build the `theory` in `session` available in `src`.
  # Additional `user_components` (e.g. the AFP) can be specified.
  build = { session, src }:
    pkgs.stdenv.mkDerivation rec {
      pname = session;
      version = "0";

      inherit src;

      nativeBuildInputs = [
        pkgs.nettools # For `hostname`
      ];

      buildPhase = ''
        export HOME=$(mktemp -d)
      
        # Copy sources and allow writing to $out/build/thys
        mkdir -p $out/build
        cp -r $src/* $out/build/
        chmod -R ug+w $out/build

        # Prebuild sources
        ${isa} build -v -d $out/build '${session}'
      '';
    };

  # Arguments are the same as `build`.
  # `dot_cabal` and `cabal_project` are cabal files which will be needed to build the project.
  # Files are stored within `$out/build`.
  export = { session, src, texlive }:
    (build { inherit session src; }).overrideAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [
        texlive
      ];

      buildPhase = (old.buildPhase or "") + ''
        mkdir -p $out/share/document
      
        # Export sources, HTML and PDF
        ${isa} build -v -e -o browser_info -o document=pdf -o document_output=$out/share/document \
          -d $out/build '${session}'
      '';

      installPhase = ''
        mkdir -p $out/share/www
      
        ln -s $(${isa} getenv ISABELLE_BROWSER_INFO) $out/share/www
      '';
    });
}




