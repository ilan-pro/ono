{ pkgs ? import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/master.tar.gz";
  }) {}
}:

let
  owiSubShell = import ./vendor/owi/shell.nix { inherit pkgs; };
in

pkgs.mkShell {
  name = "ono-dev-shell";
  dontDetectOcamlConflicts = true;
  inputsFrom = [ owiSubShell ];
  nativeBuildInputs = with pkgs.ocamlPackages; [
    bisect_ppx
    dune_3
    findlib
    menhir
    merlin
    ocaml
    ocamlformat
    ocp-browser
    odig
    odoc
    sedlex
  ];
  buildInputs = with pkgs.ocamlPackages; [
    bos
    cmdliner
    fpath
    menhirLib
    smtml
    pkgs.owi
  ];
}
