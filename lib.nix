self: { system, pkgs }:

let
  isabelle = self.packages.${system}.isabelle;

  home = "$out";
  isa-home = "$out/.${isabelle.name}";
  isa = ''
    ${isabelle}/bin/isabelle env USER_HOME=${home} ISABELLE_HOME_USER=${isa-home} ISABELLE_HEAPS=${isa-home}/heaps \
      ISABELLE_OPAM_ROOT=${isa-home}/.opam ISABELLE_STACK_ROOT=${isa-home}/.stack ISABELLE_BROWSER_INFO=${isa-home}/browser_info \
      ISABELLE_COMPONENTS_BASE=${isa-home}/contrib \
      ${isabelle}/bin/isabelle'';

  mk_dirs = components: builtins.foldl' (flags: c: "${flags} -d '${c}/lib/thys'") "" components;

  # `components` is a list of packages (for example `isabelle-afp`) which are structured so that
  # a directory `lib/thys` exists within the derivation, and points to all theories to import.
  update = components:
    # Assume that ISABELLE_HOME_USER is already set to somewhere writable
    builtins.foldl'
      (phase: c: ''
        ${phase}
        ${isa} components -u ${c}/lib/thys
      '') ""
      components;
in
rec {
  # Build the `theory` in `session` available in `src`.
  # Additional `user_components` (e.g. the AFP) can be specified.
  #
  # `user_components` is a list of package (e.g. `isabelle-afp`). It defaults to `[]`.
  build = { session, src, user_components ? [ ] }:
    pkgs.stdenv.mkDerivation rec {
      pname = session;
      version = "0";

      inherit src;

      nativeBuildInputs = [
        pkgs.nettools # For `hostname`
      ];

      buildPhase = ''
        export HOME=$(mktemp -d)
      
        # Update all components if needed
      '' + update user_components + ''

        # Copy sources and allow writing to $out/build/thys
        mkdir -p $out/build
        cp -r $src/* $out/build/
        chmod -R ug+w $out/build

        # Prebuild sources
        ${isa} build -v -d $out/build ${mk_dirs user_components} '${session}'
      '';
    };

  # Arguments are the same as `build`.
  # `dot_cabal` and `cabal_project` are cabal files which will be needed to build the project.
  # Files are stored within `$out/build`.
  export = { session, src, user_components ? [ ], texlive }:
    (build { inherit session src user_components; }).overrideAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [
        texlive
      ];

      buildPhase = (old.buildPhase or "") + ''
        mkdir -p $out/share/document
      
        # Export sources, HTML and PDF
        ${isa} build -v -e -o browser_info -o document=pdf -o document_output=$out/share/document \
          -d $out/build ${mk_dirs user_components} '${session}'
      '';

      installPhase = ''
        mkdir -p $out/share/www
      
        ln -s $(${isa} getenv ISABELLE_BROWSER_INFO) $out/share/www
      '';
    });
}




