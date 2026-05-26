(* The `ono symbolic` command. *)

open Cmdliner
open Ono_cli

let info = Cmd.info "symbolic" ~exits

let term =
  let open Term.Syntax in
  let+ () = setup_log
  and+ source_file = source_file
  and+ option_config_symb = option_config_symb in

  (match option_config_symb with
  (* fournir un chiffre négatif pour dire que nous n'avons rien donné *)
  | None -> Ono.Symbolic_ono_module.set_config_symb (-1)
  | Some n when List.mem n [ 1; 2; 3; 4; 5; 8; 9; 10; 11; 12; 13 ] ->
      Ono.Symbolic_ono_module.set_config_symb n
  | _ -> failwith "constraint invalide");

  Ono.Symbolic_driver.run ~source_file |> function
  | Ok () -> Ok ()
  | Error e -> Error (`Msg (Kdo.R.err_to_string e))

let cmd : Ono_cli.outcome Cmd.t = Cmd.v info term
