val main : unit -> Cmdliner.Cmd.Exit.code
val outcome : unit -> Ono_cli.outcome
val print_outcome : Ono_cli.outcome -> unit
val exit_code_of_result : Ono_cli.outcome -> Cmdliner.Cmd.Exit.code
