(* Command line definition commonalities. *)

open Cmdliner

type outcome = (unit, [ Ono.Error.t | Cmd.eval_error ]) Result.t

(* Exit codes. *)

let err_conversion_to_integer = 1
let err_unreachable = 2
let err_integer_divide_by_zero = 3
let err_integer_overflow = 4
let err_call_stack_exhausted = 5
let err_out_of_bounds_memory_access = 6
let err_msg = 123

let error_to_exit_code = function
  | `Msg _msg -> err_msg
  | `Unreachable -> err_unreachable
  | `Integer_divide_by_zero -> err_integer_divide_by_zero
  | `Integer_overflow -> err_integer_overflow
  | `Call_stack_exhausted -> err_call_stack_exhausted
  | `Out_of_bounds_memory_access -> err_out_of_bounds_memory_access
  | `Conversion_to_integer -> err_conversion_to_integer

let exits =
  let open Cmd.Exit in
  [
    info err_unreachable ~doc:"on unreachable instruction in Wasm code.";
    info err_integer_divide_by_zero ~doc:"on division by zero in Wasm code.";
    info err_integer_overflow ~doc:"on integer overflow in Wasm code.";
    info err_call_stack_exhausted ~doc:"on stack overflow in Wasm code.";
    info err_out_of_bounds_memory_access
      ~doc:"on out of bounds memory access in Wasm code.";
    info err_conversion_to_integer
      ~doc:"on conversion to integer error in Wasm code.";
  ]
  @ defaults

(* Common options *)

let sdocs = Manpage.s_common_options
let version = "0.0"

let log_level =
  let env = Cmd.Env.info "ONO_VERBOSITY" in
  Logs_cli.level ~env ~docs:sdocs ()

(* Arguments helpers. *)

(* il faut accepter aussi du json *)
(* même logique que pour accepter le fichier pour le premier argument FILE mais ici je spécifie l'extension qui doit être json *)
let existing_file_json =
  let parse s =
    let open Ono.Syntax in
    let* path = Fpath.of_string s in
    let* exists = Bos.OS.File.exists path in
    let json = Fpath.has_ext "json" path in
    if exists && json then Ok path
    else if not exists then Fmt.error_msg "file does not exist"
    else Fmt.error_msg "file must have .json extension"
  in
  Arg.conv (parse, Fpath.pp)

let existing_file_conv =
  let parse s =
    let open Ono.Syntax in
    let* path = Fpath.of_string s in
    let* exists = Bos.OS.File.exists path in
    if exists then Ok path else Fmt.error_msg "no file %a" Fpath.pp path
  in
  Arg.conv (parse, Fpath.pp)

(* Common arguments. *)
let setup_log =
  let open Term.Syntax in
  let+ log_level = log_level
  and+ style_renderer = Fmt_cli.style_renderer ~docs:sdocs () in
  Fmt_tty.setup_std_outputs ?style_renderer ();
  Logs.set_level log_level;
  Logs.Src.set_level Owi.Log.main_src (Some Logs.Warning);
  Logs.Src.set_level Owi.Log.bench_src None;
  let reporter = Logs_fmt.reporter () in
  Logs.set_reporter reporter

let source_file =
  let doc = "Source file to analyze." in
  Arg.(
    (* pos 0 sert à récuperer le premier argument après la commande et il est obligatoire *)
    required & pos 0 (some existing_file_conv) None (info [] ~doc ~docv:"FILE"))

(* Seed argument *)
let seed =
  let doc = "Seed for random number generator." in
  (* le opt + info["seed"] permet d'écrire --seed pour le parser *)
  (* some int pour dire qu'on attends un argument entier genre seed 42 *)
  (* None est la valeur par défaut s'il ne passe rien cela nous permettra d'appeler self_init quand c none*)
  (* value rend l'argument optionnel *)
  (* le doc c pour ajouter la docu au help et donner la valeur que prend le seed *)
  Arg.(value & opt (some int) None & info [ "seed" ] ~doc ~docv:"INT")

(* Définition de l'option seed pour la CLI *)

let steps =
  let doc = "Step pour limiter le nbr d'itération TODO" in
  Arg.(value & opt (some int) None & info [ "steps" ] ~doc ~docv:"INT")

let json_config =
  let doc = "File JSON for handmade configuration" in
  Arg.(
    value
    & opt (some existing_file_json) None
    & info [ "config" ] ~doc ~docv:"CONFIG")
