{
  description = "Isabelle2022 with a better LSP integration (specifically useful for emacs)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { };
      polyml = pkgs.callPackage ./polyml.nix { };
      isabelle = pkgs.callPackgae ./isabelle.nix { inherit polyml; };
    in
    {
      overlays.default = final: prev: {
        inherit isabelle polyml;
      };
    };
}
