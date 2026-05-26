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
  and+ symbolic_configuration = symbolic_configuration
  and+ test = test
  and+ steps = steps
  and+ last = last
  and+ graphical_option = graphical_option in

  (match last with
  | Some n -> (
      (* dansle cas ou last est présent mais pas steps alors il y a un gros problème et nous devons
    lever une exception ! *)
      match steps with
      | None ->
          failwith
            "last présent mais steps est absent ce qui n'est pas cohérent pour \
             le moteur..."
      | Some _ -> Ono.Concrete_ono_module.set_last_arg n)
  | None -> ());

  (match test with
  | Some n -> Ono.Concrete_ono_module.set_test n
  | None -> Ono.Concrete_ono_module.set_test 0);

  (* pour générer la seed *)
  (match seed with Some n -> Random.init n | None -> Random.self_init ());

  (match steps with
  | Some n -> Ono.Concrete_ono_module.set_steps_arg n
  (* 0 nous permettra de détecter qu'il faut un nombre infini d'étapes même si la ref est déjà à 0, par sécurité...*)
  | None -> Ono.Concrete_ono_module.set_steps_arg 0);

  (* pour l'option graphique *)
  (* comme l'argument est obligatoire (required), le cmdLiner l'a déjà simplifier en int *)
  if graphical_option then Ono.Concrete_ono_module.set_option_graphic 1
  else Ono.Concrete_ono_module.set_option_graphic 0;

  let symbolic =
    match symbolic_configuration with
    | None -> None
    | Some path ->
        (* même logique que plus bas *)
        let content = Bos.OS.File.read path |> Result.to_option in
        Option.map Yojson.Safe.from_string content
  in

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

  Ono.Concrete_driver.run ~source_file ?json ?symbolic () |> function
  | Ok () -> Ok ()
  | Error e -> Error (`Msg (Kdo.R.err_to_string e))

let cmd : Ono_cli.outcome Cmd.t = Cmd.v info term
