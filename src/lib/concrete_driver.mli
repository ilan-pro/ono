(** Pipeline d'exécution concrète : parse, link, interprète. *)

val run :
  source_file:Fpath.t ->
  ?json:Yojson.Safe.t ->
  ?symbolic:Yojson.Safe.t ->
  unit ->
  unit Kdo.R.t
