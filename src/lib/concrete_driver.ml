open Concrete_config
open Syntax
module Interpret = Kdo.Interpret.Concrete (Kdo.Interpret.Default_parameters)

let run ~source_file ?json ?symbolic () =
  let config_json =
    match json with None -> None | Some js -> Some (parse_config js)
  in
  (match config_json with
  | None -> Logs.info (fun m -> m "No config json, using defaults")
  | Some conf ->
      Logs.info (fun m ->
          m "Run with width:%d height:%d" conf.width conf.length));

  (* je donne la config à mon module ono via reference *)
  global_config := config_json;

  (* on ouvre le fichier json avec les dimensions afin de l'envoyer en paramètre de notre parser pour qu'il 
  puisse créer alive *)
  let json_symbolic =
    (* le chemin vers le fichier en Fpath *)
    let path = Fpath.v "config/symbolic_dimension.json" in
    (* on créé le fichier json en Yojson *)
    let content = Bos.OS.File.read path |> Result.to_option in
    Option.map Yojson.Safe.from_string content
  in
  let config_symbolic =
    match symbolic with
    | None -> None
    | Some symbolic_value -> (
        match json_symbolic with
        | None -> None
        | Some symbolic_dimension ->
            Some (parse_json_to_symbolic symbolic_value symbolic_dimension))
  in
  (match config_symbolic with
  | None -> Logs.info (fun m -> m "No config xml, using defaults")
  | Some _ ->
      global_config := config_symbolic;
      Logs.info (fun m -> m "Run with symbolic config xml ")
      (* je donne la config à mon module ono via reference *));

  (* Parsing. *)
  Logs.info (fun m -> m "Parsing file %a..." Fpath.pp source_file);
  let* wat_module = Kdo.Parse.Wat.Module.from_file source_file in
  Logs.debug (fun m ->
      m "Parsed module is:  @\n@[<v>%a@]" Kdo.Wat.Module.pp wat_module);

  (* Compiling to Wasm. *)
  Logs.info (fun m -> m "Compiling to Wasm...");
  let* wasm_module = Kdo.Compile.Wat.until_wasm ~unsafe:false wat_module in
  Logs.debug (fun m ->
      m "Compiled module is:  @\n@[<v>%a@]" Kdo.Wasm.Module.pp wasm_module);

  (* Validation step. *)
  Logs.info (fun m -> m "Validating...");
  let* () = Kdo.Validate.Wasm.modul wasm_module in

  (* Linking. *)
  Logs.info (fun m -> m "Linking...");
  let link_state : Kdo.Concrete.Extern_func.extern_func Kdo.Link.State.t =
    Kdo.Link.State.empty ()
  in
  let link_state =
    Kdo.Link.Extern.modul Concrete_ono_module.m link_state ~name:"ono"
  in
  let name = Some (Fpath.to_string source_file) in
  let* linked_module, link_state =
    Kdo.Link.Wasm.modul link_state ~name wasm_module
  in

  (* Interpreting. *)
  Logs.info (fun m -> m "Interpreting...");
  Interpret.modul link_state linked_module