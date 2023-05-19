{
  description = "Isabelle2022 with a better LSP integration (specifically useful for emacs)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        polyml = pkgs.callPackage ./polyml.nix { };
        isabelle = pkgs.callPackage ./isabelle.nix { inherit polyml; };
      in
      {
        packages = { inherit isabelle polyml; };
      }
    );
}
