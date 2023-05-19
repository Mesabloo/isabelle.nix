{
  description = "Isabelle2022 with a better LSP integration (specifically useful for emacs)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
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
        pkgs = import nixpkgs { inherit system; };
        polyml = pkgs.callPackage ./polyml.nix { };
        z3 = pkgs.callPackage ./z3.nix { };
        isabelle = pkgs.callPackage ./isabelle.nix { inherit polyml z3; };
      in
      {
        packages = { inherit isabelle polyml; };
      }
    );
}
