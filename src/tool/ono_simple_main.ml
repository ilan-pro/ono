(* Simplified ono concrete executable *)

open Cmdliner

let exits = Cmd.Exit.defaults

let log_level =
  let env = Cmd.Env.info "ONO_VERBOSITY" in
  Logs_cli.level ~env ~docs:Cmdliner.Manpage.s_common_options ()

let setup_log =
  let open Term.Syntax in
  let+ log_level = log_level
  and+ style_renderer = Fmt_cli.style_renderer ~docs:Cmdliner.Manpage.s_common_options () in
  Fmt_tty.setup_std_outputs ?style_renderer ();
  Logs.set_level log_level;
  Logs.Src.set_level Owi.Log.main_src (Some Logs.Warning);
  Logs.Src.set_level Owi.Log.bench_src None;
  let reporter = Logs_fmt.reporter () in
  Logs.set_reporter reporter

let existing_file_conv =
  let parse s =
    let open Ono.Syntax in
    let* path = Fpath.of_string s in
    let* exists = Bos.OS.File.exists path in
    if exists then Ok path else Fmt.error_msg "no file %a" Fpath.pp path
  in
  Arg.conv (parse, Fpath.pp)

let source_file =
  let doc = "Source file to analyze." in
  Arg.(
    required & pos 0 (some existing_file_conv) None (info [] ~doc ~docv:"FILE"))

let seed =
  let doc = "Seed for random number generation." in
  Arg.(value & opt (some int) None & info [ "seed" ] ~doc)

let info = Cmd.info "ono_concrete" ~exits

let term =
  let open Term.Syntax in
  let+ () = setup_log and+ source_file = source_file and+ seed = seed in
  Ono.Concrete_driver.run ~source_file ~seed |> function
  | Ok () -> Ok ()
  | Error e -> Error (`Msg (Kdo.R.err_to_string e))

let () = 
  match Cmd.v info term |> Cmd.eval with
  | Ok () -> ()
  | Error _ -> exit 1
