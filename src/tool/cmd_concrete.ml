(* The `ono concrete` command. *)

open Cmdliner
open Ono_cli

let info = Cmd.info "concrete" ~exits

let term =
  let open Term.Syntax in
  (* les + servent à concatenner les argments/options de la cmd *)
  let+ () = setup_log 
  and+ source_file = source_file 
  and+ seed = seed in
  (match seed with
    | Some n -> Random.init n
    | None -> Random.self_init());
    (* c ici que le moteur d'owi execute les .wat *)
  Ono.Concrete_driver.run ~source_file |> function
  | Ok () -> Ok ()
  | Error e -> Error (`Msg (Kdo.R.err_to_string e))

let cmd : Ono_cli.outcome Cmd.t = Cmd.v info term
