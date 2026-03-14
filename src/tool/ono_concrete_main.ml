(* Simplified ono concrete executable *)

open Cmdliner
open Ono_cli

let info = Cmd.info "run" ~exits

let term =
  let open Term.Syntax in
  let+ () = setup_log and+ source_file = source_file and+ seed = seed in
  (match seed with Some s -> Random.init s | None -> Random.self_init ());
  Ono.Concrete_driver.run ~source_file |> function
  | Ok () -> Ok ()
  | Error e -> Error (`Msg (Kdo.R.err_to_string e))

let cmd : Ono_cli.outcome Cmd.t = Cmd.v info term

let () = Cmd.v (Cmd.info "ono_concrete") term |> Cmd.eval
