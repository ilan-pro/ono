(** Options et arguments communs à [ono]. *)

type outcome = (unit, [ Ono.Error.t | Cmdliner.Cmd.eval_error ]) result

val error_to_exit_code : Ono.Error.t -> int
val exits : Cmdliner.Cmd.Exit.info list
val version : string
val sdocs : string
val setup_log : unit Cmdliner.Term.t
val source_file : Fpath.t Cmdliner.Term.t
val seed : int option Cmdliner.Term.t
val steps : int option Cmdliner.Term.t
val test : int option Cmdliner.Term.t
val json_config : Fpath.t option Cmdliner.Term.t
val symbolic_configuration : Fpath.t option Cmdliner.Term.t
val last : int option Cmdliner.Term.t
val graphical_option : bool Cmdliner.Term.t
val option_config_symb : int option Cmdliner.Term.t
