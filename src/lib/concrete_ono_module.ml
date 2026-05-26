open Concrete_config

type extern_func = Kdo.Concrete.Extern_func.extern_func

let buffer = Buffer.create 4096

let print_i32 (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

(** Petit module de maths *)
let print_i32_custom (i : Kdo.Concrete.I32.t) (j : Kdo.Concrete.I32.t) :
    (unit, _) Result.t =
  Logs.app (fun m -> m "%a %a" Kdo.Concrete.I32.pp i Kdo.Concrete.I32.pp j);
  Ok ()

let print_i64 (n : Kdo.Concrete.I64.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I64.pp n);
  Ok ()

let newline () : (unit, _) Result.t =
  Buffer.add_char buffer '\n';
  Ok ()

let clear_screen () : (unit, _) Result.t =
  Buffer.output_buffer stdout buffer;
  flush stdout;
  Buffer.clear buffer;
  Ok ()

let random_i32 (n : Kdo.Concrete.I32.t) : (Kdo.Concrete.I32.t, _) Result.t =
  (* La fonction prend un paramètre n et retourne un nombre aléatoire entre 0 et n-1 *)
  let vall = Kdo.Concrete.I32.to_int n in
  let max_val = if vall <= 0 then 1 else vall in
  let random_val = Random.int max_val in
  Ok (Kdo.Concrete.I32.of_int random_val)

let debogue_index (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "indice : %a" Kdo.Concrete.I32.pp n);
  Ok ()

let debogue_valeur (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "valeur : %a" Kdo.Concrete.I32.pp n);
  Ok ()

let print_separateur (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  (* on affiche réellement les vrais numéros d'itérations pas celle de la boucle (i commencant à 0 c'est moins) *)
  let print_ite = Kdo.Concrete.I32.to_int n in
  let print_ite_real = print_ite + 1 in
  Logs.app (fun m ->
      m "-------------itération %a-----------------" Kdo.Concrete.I32.pp
        (Kdo.Concrete.I32.of_int print_ite_real));
  Ok ()

let sleep () : (unit, _) Result.t =
  Unix.sleep 1;
  Ok ()

let cell_print (x : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  if x <> Kdo.Concrete.I32.of_int 0 then Buffer.add_string buffer "🦊 "
  else Buffer.add_string buffer ".  ";
  Ok ()

let steps_arg = ref 0
let set_steps_arg n = steps_arg := n
let test = ref 0
let set_test n = test := n

let get_test () : (Kdo.Concrete.I32.t, _) Result.t =
  Ok (Kdo.Concrete.I32.of_int !test)

let get_steps () : (Kdo.Concrete.I32.t, _) Result.t =
  Ok (Kdo.Concrete.I32.of_int !steps_arg)

let last_arg = ref 0
let set_last_arg n = last_arg := n

let get_last () : (Kdo.Concrete.I32.t, _) Result.t =
  Ok (Kdo.Concrete.I32.of_int !last_arg)

let config_not_null () : (Kdo.Concrete.I32.t, _) Result.t =
  let value = if !global_config <> None then 1 else 0 in
  Ok (Kdo.Concrete.I32.of_int value)

let get_width () : (Kdo.Concrete.I32.t, _) Result.t =
  let width = match !global_config with Some conf -> conf.width | None -> 0 in
  let value = if width > 0 then width else 0 in
  Ok (Kdo.Concrete.I32.of_int value)

let get_length () : (Kdo.Concrete.I32.t, _) Result.t =
  let length =
    match !global_config with Some conf -> conf.length | None -> 0
  in
  let value = if length > 0 then length else 0 in
  Ok (Kdo.Concrete.I32.of_int value)

let get_alive (i : Kdo.Concrete.I32.t) (j : Kdo.Concrete.I32.t) :
    (Kdo.Concrete.I32.t, _) Result.t =
  let i = Kdo.Concrete.I32.to_int i in
  let j = Kdo.Concrete.I32.to_int j in
  let alive =
    match !global_config with Some conf -> conf.alive | None -> []
  in
  let value =
    if List.exists (fun (x, y) -> x = i && y = j) alive then 1 else 0
  in
  Ok (Kdo.Concrete.I32.of_int value)

let read_int () : (Kdo.Concrete.I32.t, _) Result.t =
  let n = Scanf.scanf " %d" (fun x -> x) in
  Ok (Kdo.Concrete.I32.of_int n)

let dimension (forRow : Kdo.Concrete.I32.t) : (Kdo.Concrete.I32.t, _) Result.t =
  let res = Kdo.Concrete.I32.to_int forRow in
  if res > 0 then print_string "Entrez une longueur : "
  else print_string "Entrez une largeur : ";
  flush stdout;
  read_int ()

open Raylib

type camera = {
  mutable offset_x : int;
  mutable offset_y : int;
  mutable cell_size : int;
}

let camera = { offset_x = 0; offset_y = 0; cell_size = 20 }

let open_window () : (unit, _) Result.t =
  Raylib.init_window 800 800 "Game of life";
  Raylib.set_target_fps 60;
  Ok ()

(* fonction de raylib qui premet de récup la taille de la fenetre*)
let window_width () = Raylib.get_screen_width ()
let window_height () = Raylib.get_screen_height ()

let visible_cols window_width camera =
  let size = max 1 camera.cell_size in
  (window_width + size - 1) / size

let visible_rows window_height camera =
  let size = max 1 camera.cell_size in
  (window_height + size - 1) / size

let init_camera ~grid_width ~grid_height =
  let size_x = (window_width () + grid_width - 1) / max 1 grid_width in
  let size_y = (window_height () + grid_height - 1) / max 1 grid_height in
  camera.cell_size <- max 1 (min size_x size_y);
  camera.offset_x <- 0;
  camera.offset_y <- 0

let is_close () : (Kdo.Concrete.I32.t, _) Result.t =
  let b = if window_should_close () then 0 else 1 in
  Ok (Kdo.Concrete.I32.of_int b)

let close_window () : (unit, _) Result.t =
  Raylib.close_window ();
  Ok ()

let begin_drawing () : (unit, _) Result.t =
  Raylib.begin_drawing ();
  Ok ()

let end_drawing () : (unit, _) Result.t =
  Raylib.end_drawing ();
  Ok ()

let clear_background () : (unit, _) Result.t =
  Raylib.clear_background Raylib.Color.raywhite;
  Ok ()

let clamp_camera ~grid_width ~grid_height =
  let cols = visible_cols (window_width ()) camera in
  let rows = visible_rows (window_height ()) camera in
  let max_offset_x = max 0 (grid_width - cols) in
  let max_offset_y = max 0 (grid_height - rows) in
  camera.offset_x <- max 0 (min camera.offset_x max_offset_x);
  camera.offset_y <- max 0 (min camera.offset_y max_offset_y)

let fit_cell_size ~grid_width ~grid_height =
  let size_x = (window_width () + grid_width - 1) / max 1 grid_width in
  let size_y = (window_height () + grid_height - 1) / max 1 grid_height in
  max 1 (min size_x size_y)

let max_cell_size = 200

let handle_camera_input ~grid_width ~grid_height =
  if Raylib.is_key_down Raylib.Key.Right then
    camera.offset_x <- camera.offset_x + 1;

  if Raylib.is_key_down Raylib.Key.Left then
    camera.offset_x <- camera.offset_x - 1;

  if Raylib.is_key_down Raylib.Key.Down then
    camera.offset_y <- camera.offset_y + 1;

  if Raylib.is_key_down Raylib.Key.Up then
    camera.offset_y <- camera.offset_y - 1;

  if Raylib.is_key_down Raylib.Key.P then begin
    let cols_before = window_width () / camera.cell_size in
    let rows_before = window_height () / camera.cell_size in

    let center_x = camera.offset_x + (cols_before / 2) in
    let center_y = camera.offset_y + (rows_before / 2) in

    camera.cell_size <- min max_cell_size (camera.cell_size + 2);

    let cols_after = window_width () / camera.cell_size in
    let rows_after = window_height () / camera.cell_size in

    camera.offset_x <- center_x - (cols_after / 2);
    camera.offset_y <- center_y - (rows_after / 2);

    clamp_camera ~grid_width ~grid_height
  end;

  if Raylib.is_key_down Raylib.Key.O then begin
    let cols_before = window_width () / camera.cell_size in
    let rows_before = window_height () / camera.cell_size in

    let center_x = camera.offset_x + (cols_before / 2) in
    let center_y = camera.offset_y + (rows_before / 2) in

    let min_cell_size = fit_cell_size ~grid_width ~grid_height in
    camera.cell_size <- max min_cell_size (camera.cell_size - 2);

    let cols_after = window_width () / camera.cell_size in
    let rows_after = window_height () / camera.cell_size in

    camera.offset_x <- center_x - (cols_after / 2);
    camera.offset_y <- center_y - (rows_after / 2);

    clamp_camera ~grid_width ~grid_height
  end;

  clamp_camera ~grid_width ~grid_height

let camera_initialized = ref false

let handle_camera_input_ext (grid_width : Kdo.Concrete.I32.t)
    (grid_height : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  let grid_width = Kdo.Concrete.I32.to_int grid_width in
  let grid_height = Kdo.Concrete.I32.to_int grid_height in

  if not !camera_initialized then begin
    init_camera ~grid_width ~grid_height;
    camera_initialized := true
  end;

  handle_camera_input ~grid_width ~grid_height;
  Ok ()

let cell_print_inter (is_alive : Kdo.Concrete.I32.t) (row : Kdo.Concrete.I32.t)
    (column : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  let row = Kdo.Concrete.I32.to_int row in
  let column = Kdo.Concrete.I32.to_int column in

  let cols = visible_cols (window_width ()) camera in
  let rows = visible_rows (window_height ()) camera in

  let screen_x = column - camera.offset_x in
  let screen_y = row - camera.offset_y in

  if screen_x >= 0 && screen_x < cols && screen_y >= 0 && screen_y < rows then begin
    let size = max 1 camera.cell_size in
    let pixel_x = screen_x * size in
    let pixel_y = screen_y * size in

    if is_alive <> Kdo.Concrete.I32.of_int 0 then
      draw_rectangle pixel_x pixel_y size size Color.black
    else draw_rectangle pixel_x pixel_y size size Color.red;

    draw_rectangle_lines pixel_x pixel_y size size Color.blue
  end;

  Ok ()

(* quand la valeur est à 0, c'est le terminal qui est affiché et à 1 c'est la fenêtre *)
let option_graphic = ref 0
let set_option_graphic n = option_graphic := n

let get_option_graphic () : (Kdo.Concrete.I32.t, _) Result.t =
  Ok (Kdo.Concrete.I32.of_int !option_graphic)

let print_iteration_graphic (iter : Kdo.Concrete.I32.t)
    (max_iter : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  let text =
    if Kdo.Concrete.I32.to_int max_iter == 0 then
      Printf.sprintf "%d" (Kdo.Concrete.I32.to_int iter)
    else
      Printf.sprintf "%d/%d"
        (Kdo.Concrete.I32.to_int iter)
        (Kdo.Concrete.I32.to_int max_iter)
  in
  Ok (draw_text text 0 0 10 Color.white)

let m =
  let open Kdo.Concrete.Extern_func in
  let open Kdo.Concrete.Extern_func.Syntax in
  let functions =
    [
      (* pour les entiers *)
      ("print_i32", Extern_func (i32 ^->. unit, print_i32));
      ("print_i64", Extern_func (i64 ^->. unit, print_i64));
      ("random_i32", Extern_func (i32 ^->. i32, random_i32));
      ("print_i32_custom", Extern_func (i32 ^-> i32 ^->. unit, print_i32_custom));
      (* pour le formatage *)
      ("newline", Extern_func (unit ^->. unit, newline));
      ("clear_screen", Extern_func (unit ^->. unit, clear_screen));
      ("print_separateur", Extern_func (i32 ^->. unit, print_separateur));
      ("sleep", Extern_func (unit ^->. unit, sleep));
      (* l'affichage logique *)
      ("cell_print", Extern_func (i32 ^->. unit, cell_print));
      (* pour le debug *)
      ("debogue_index", Extern_func (i32 ^->. unit, debogue_index));
      ("debogue_valeur", Extern_func (i32 ^->. unit, debogue_valeur));
      ("get_steps", Extern_func (unit ^->. i32, get_steps));
      ("get_test", Extern_func (unit ^->. i32, get_test));
      ("get_last", Extern_func (unit ^->. i32, get_last));
      ("config_not_null", Extern_func (unit ^->. i32, config_not_null));
      ("get_width", Extern_func (unit ^->. i32, get_width));
      ("get_length", Extern_func (unit ^->. i32, get_length));
      ("get_alive", Extern_func (i32 ^-> i32 ^->. i32, get_alive));
      (* pour la saisie utilisateur *)
      ("dimension", Extern_func (i32 ^->. i32, dimension));
      (* pour l'option graphique *)
      ("get_option_graphic", Extern_func (unit ^->. i32, get_option_graphic));
      (* pour le graphique *)
      ("open_window", Extern_func (unit ^->. unit, open_window));
      ("close_window", Extern_func (unit ^->. unit, close_window));
      ("is_close", Extern_func (unit ^->. i32, is_close));
      ("end_drawing", Extern_func (unit ^->. unit, end_drawing));
      ("begin_drawing", Extern_func (unit ^->. unit, begin_drawing));
      ("clear_background", Extern_func (unit ^->. unit, clear_background));
      ( "cell_print_inter",
        Extern_func (i32 ^-> i32 ^-> i32 ^->. unit, cell_print_inter) );
      ( "print_iteration_graphic",
        Extern_func (i32 ^-> i32 ^->. unit, print_iteration_graphic) );
      ( "handle_camera_input",
        Extern_func (i32 ^-> i32 ^->. unit, handle_camera_input_ext) );
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }
