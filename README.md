This is a simple Nix flake for Isabelle 2022 based on [isabelle-emacs](https://github.com/m-fleury/isabelle-emacs) (branch `Isabelle2022-more-vscode`).

Simply add it as an input to your flake (`isabelle2022.url = "github:Mesabloo/isabelle.nix";`) and you should be ready to go.

# Accessing a few useful functions 

This flake exports a very small library which needs a few parameters:
- `system` is the current system;
- `pkgs` is the package set (most likely `import nixpkgs { inherit system; }` or something similar);
- `isabelle` which is the Isabelle installation to be used (see below).

It's a good idea to set `isabelle-lib = isabelle2022.lib { inherit system pkgs isabelle; }` to avoid repeating it in multiple places.

# Using components such as the AFP 

Isabelle, by default, only ships with default components. 
If you want to use say the AFP or the Isabelle_LLVM project, you need to specify it explicitly using `withComponents` as follows:
```nix
isabelle = isabelle2022.packages.${system}.isabelle.withComponents [ 
  # Any component or some of the packaged ones here:
  # isabelle2022.packages.${system}.isabelle-afp 
  # isabelle2022.packages.${system}.isabelle-llvm
]
```

In any case, if you are planning on using Emacs with isabelle-emacs (instead of the packaged JEdit-based IDE) then you will also need to add `isabelle-lib.custom-emacs` to your `devShell` build inputs.
This will create a small wrapper script which sets the correct path to the LSP server (which will be in the Nix store).

# Building an Isabelle project 

The small library exposes a function `export` which takes the following parameters:
- `src` is a path or a derivation containing Isabelle source code and a `ROOTS` or `ROOT` file;
- `session` is the name of the session in the source directory to be exported (to e.g. Haskell, SML, etc.);
- `texlive` is a texlive package to be used to compile LaTeX sources. 
  It is likely to be required to be `pkgs.texlive.combined.scheme-full` in all cases.

The function returns a derivation containing the original sources as well as exported (Haskell, SML, etc.) source code, LaTeX sources, HTML sources and generated PDF.
- The (Haskell, SML, etc.) exported source code is simply put in the directory of the Isabelle theories, as would `isabelle build -e` would do;
- LaTeX sources and PDF are put in `$out/share/document`;
- HTML sources are put in `$out/www`.
