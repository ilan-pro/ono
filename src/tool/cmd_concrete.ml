(* The `ono concrete` command. *)

open Cmdliner
open Ono_cli

let info = Cmd.info "concrete" ~exits

let term =
  let open Term.Syntax in
  (* les + servent à concatenner les argments/options de la cmd *)
  let+ () = setup_log
  and+ source_file = source_file
  and+ seed = seed
  and+ json_config = json_config
  and+ steps = steps
  and+ last = last
  and+ option_graphic = option_graphic in

  (match last with
  | Some n -> Ono.Concrete_ono_module.set_last_arg n
  | None -> Ono.Concrete_ono_module.set_last_arg 8);

  (* pour générer la seed *)
  (match seed with Some n -> Random.init n | None -> Random.self_init ());
  (match steps with
  | Some n -> Ono.Concrete_ono_module.set_steps_arg n
  | None -> Ono.Concrete_ono_module.set_steps_arg 8);

  (* pour l'option graphique *)
  (* comme l'argument est obligatoire (required), le cmdLiner l'a déjà simplifier en int *)
  if option_graphic > 0 then Ono.Concrete_ono_module.set_option_graphic 1
  else Ono.Concrete_ono_module.set_option_graphic 0;

  (* le fichier json *)
  let json =
    match json_config with
    | None -> None
    | Some path ->
        (* Bos.OS... sert à transformer le fichier sous forme de result string pour ensuite le transformer
        en Yojson.safe.t *)
        let content = Bos.OS.File.read path |> Result.to_option in
        (* le format yojson est une bibliothèque d'ocaml pour exploiter du json sous forme d'arbre syntaxique *)
        Option.map Yojson.Safe.from_string content
  in

  (* c ici que le moteur d'owi execute les .wat *)
  (* todo : on ajouter () pour ... *)
  Ono.Concrete_driver.run ~source_file ?json () |> function
  | Ok () -> Ok ()
  | Error e -> Error (`Msg (Kdo.R.err_to_string e))

let cmd : Ono_cli.outcome Cmd.t = Cmd.v info term
