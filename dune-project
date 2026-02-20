(lang dune 3.7)
(generate_opam_files true)
(using directory-targets 0.1)
(using menhir 2.1)
(name ono)
(license AGPL-3.0-or-later)
(authors "TODO")
(maintainers "TODO")
(homepage "TODO")
(bug_reports "TODO")
(package
 (name ono)
 (synopsis "TODO")
 (depends
  (ocaml (>= 5.3))
  (cmdliner (>= 1.3.0))
  z3       ; <-- AJOUTER
  bitv     ; <-- AJOUTER
  smtml))  ; <-- AJOUTER