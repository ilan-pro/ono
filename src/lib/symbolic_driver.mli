(** Pipeline d'exécution symbolique : parse, link, interprète. *)

val run : source_file:Fpath.t -> unit Kdo.R.t
