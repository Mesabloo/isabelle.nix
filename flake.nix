{
  description = "Isabelle2022 with a better LSP integration (specifically useful for emacs)";

  inputs = {
    # We need Z3 v4.4.0 absolutely. newer versions don't work.
    nixpkgs.url = "github:nixos/nixpkgs?rev=4d2b37a84fad1091b9de401eb450aae66f1a741e";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      systems = with flake-utils.lib; [
        system.x86_64-linux
        # Sorry if you are on any other system, but we require some packages which
        # can't be installed there.
      ];
    in
    flake-utils.lib.eachSystem systems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        polyml = pkgs.callPackage ./polyml.nix { };
        isabelle = pkgs.callPackage ./isabelle.nix { inherit polyml; z3 = pkgs.z3_4_4_0; };
        # Create a fake "emacs" executable which sets the correct path to the LSP server at startup.
        emacs = pkgs.writeShellScriptBin "emacs" ''
          ${pkgs.emacs}/bin/emacs --eval '(setq lsp-isar-path-to-isabelle "${isabelle}/bin")' "$@"
        '';
      in
      {
        packages = { inherit isabelle polyml emacs; };
      }
    );
}
