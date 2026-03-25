open Concrete_config
open Raylib

type extern_func = Kdo.Concrete.Extern_func.extern_func

let buffer = Buffer.create 4096

let width_ref = ref 0
let length_ref = ref 0
let read_int_count = ref 0

let capture_mode = ref false
let current_snapshot : bool array option ref = ref None
let snapshots : bool array list ref = ref []

let effective_width () = if !width_ref > 0 then !width_ref else 1
let effective_length () = if !length_ref > 0 then !length_ref else 1

let ui_grid_height = 700
let ui_window_height = 800
let ui_width = 800
let ui_button_margin = 10
let ui_button_w = 100
let ui_button_h = 40
let ui_font_size = 20

let grid_cell_w () =
  float_of_int ui_width /. float_of_int (effective_width ())

let grid_cell_h () =
  float_of_int ui_grid_height /. float_of_int (effective_length ())

let print_i32 (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

let print_i32_custom (i : Kdo.Concrete.I32.t) (j : Kdo.Concrete.I32.t) :
    (unit, _) Result.t =
  Logs.app (fun m -> m "%a %a" Kdo.Concrete.I32.pp i Kdo.Concrete.I32.pp j);
  Ok ()

let print_i64 (n : Kdo.Concrete.I64.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I64.pp n);
  Ok ()

let newline () : (unit, _) Result.t =
  if !capture_mode then Ok ()
  else (
    Buffer.add_char buffer '\n';
    Ok ())

let clear_screen () : (unit, _) Result.t =
  Buffer.output_buffer stdout buffer;
  flush stdout;
  Buffer.clear buffer;
  Ok ()

let random_i32 (n : Kdo.Concrete.I32.t) : (Kdo.Concrete.I32.t, _) Result.t =

  let max_val : int32 = Obj.magic n in
  let max_val = Int32.to_int max_val in
  let max_val = if max_val <= 0 then 1 else max_val in
  let random_val = Random.int max_val in
  Ok (Kdo.Concrete.I32.of_int random_val)

let debogue_index (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "indice : %a" Kdo.Concrete.I32.pp n);
  Ok ()

let debogue_valeur (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "valeur : %a" Kdo.Concrete.I32.pp n);
  Ok ()

let print_separateur (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  Logs.app (fun m ->
      m "-------------itération %a-----------------" Kdo.Concrete.I32.pp n);
  Ok ()

let sleep (x : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  let n : int32 = Obj.magic x in
  Unix.sleep (Int32.to_int n);
   Ok ()

let cell_print (x : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  if x <> Kdo.Concrete.I32.of_int 0 then Buffer.add_string buffer "🦊 "
  else Buffer.add_string buffer "x  ";
  Ok ()



let steps_arg = ref 0
let set_steps_arg n = steps_arg := n


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
  let i : int32 = Obj.magic i in
  let j : int32 = Obj.magic j in
  let i = Int32.to_int i in
  let j = Int32.to_int j in
  let alive =
    match !global_config with Some conf -> conf.alive | None -> []
  in
  let value =
    if List.exists (fun (x, y) -> x = i && y = j) alive then 1 else 0
  in
  Ok (Kdo.Concrete.I32.of_int value)
let read_int () : (Kdo.Concrete.I32.t, _) Result.t =
  print_string "Entrez une valeur : ";
  flush stdout;
  let n = Scanf.scanf " %d" (fun x -> x) in
  incr read_int_count;

  (match !read_int_count with
  | 1 -> width_ref := n
  | 2 -> length_ref := n
  | _ -> ());
  Ok (Kdo.Concrete.I32.of_int n)

  let open_window () : (unit,_) Result.t =
     width_ref := !width_ref;
     length_ref := !length_ref;
     snapshots := [];
     current_snapshot := None;
     capture_mode := true;
     read_int_count := !read_int_count;
     init_window ui_width ui_window_height "Game of life";
     Raylib.set_target_fps 60;
    Ok()

  
  let close_window () : (unit,_) Result.t =
    close_window();
    Ok() 

  let is_close () : (Kdo.Concrete.I32.t,_) Result.t =
    let b = if window_should_close() then 0 else 1 in
    Ok(Kdo.Concrete.I32.of_int b)

  let begin_drawing () : (unit,_) Result.t =
    if !capture_mode then (
      let w = effective_width () in
      let l = effective_length () in
      current_snapshot := Some (Array.make (w * l) false);
      Ok () )
    else (
      Raylib.begin_drawing ();
    Ok()
    )
  
  let end_drawing () : (unit,_) Result.t =
    if !capture_mode then (
      (match !current_snapshot with
      | Some snap -> snapshots := snap :: !snapshots
      | None -> ());
      current_snapshot := None;
      Ok () )
    else (
      Raylib.end_drawing ();
      Ok () )
  
  let clear_background () : (unit,_) Result.t =
    if !capture_mode then Ok ()
    else (
      Raylib.clear_background Color.raywhite;
      Ok ())

  let cell_print_inter (is_alive : Kdo.Concrete.I32.t) (row : Kdo.Concrete.I32.t) (column : Kdo.Concrete.I32.t) : (unit, _) Result.t =
      let col32 : int32 = Obj.magic column in
      let row32 : int32 = Obj.magic row in
      let col = Int32.to_int col32 in
      let row = Int32.to_int row32 in
      if !capture_mode then (
        match !current_snapshot with
        | None -> Ok ()
        | Some snap ->
            let w = effective_width () in
            let idx = (row * w) + col in
            if idx >= 0 && idx < Array.length snap then
              snap.(idx) <- (is_alive <> Kdo.Concrete.I32.of_int 0);
            Ok () )
      else (
        
        let cell_w = grid_cell_w () in
        let cell_h = grid_cell_h () in
        let x = float_of_int col *. cell_w in
        let y = float_of_int row *. cell_h in
        let pos = Vector2.create x y in
        let size = Vector2.create cell_w cell_h in
        if is_alive <> Kdo.Concrete.I32.of_int 0 then (
          Raylib.draw_rectangle_v pos size Color.black
        ) else (
          Raylib.draw_rectangle_v pos size Color.red
        );
        Raylib.draw_rectangle_lines (int_of_float x) (int_of_float y) (int_of_float cell_w)
          (int_of_float cell_h) Color.blue;
        Ok () )

  let run_ui () : (unit, _) Result.t =
    capture_mode := false;
    let snaps = List.rev !snapshots in
    let snapshots_arr = Array.of_list snaps in
    let selected = ref 0 in
    let total = Array.length snapshots_arr in
    let deadline =
      match Sys.getenv_opt "ONO_GUI_AUTOCLOSE_SEC" with
      | None -> None
      | Some s -> (
          let seconds =
            try Some (float_of_string s) with _ -> None
          in
          match seconds with
          | None -> None
          | Some seconds -> Some (Unix.gettimeofday () +. seconds))
    in

    let prev_x = ui_button_margin in
    let prev_y = ui_grid_height + ui_button_margin in
    let next_x = prev_x + ui_button_w + ui_button_margin in
    let next_y = ui_grid_height + ui_button_margin in

    let in_rect mx my x y w h =
      mx >= x && mx <= (x + w) && my >= y && my <= (y + h)
    in

    let mouse_pressed_prev = ref false in
    
    while
      (not (Raylib.window_should_close ()))
      && (match deadline with
         | None -> true
         | Some d -> Unix.gettimeofday () <= d)
    do
      Raylib.poll_input_events ();

      let mx = Raylib.get_mouse_x () in
      let my = Raylib.get_mouse_y () in
      let mouse_now_pressed = Raylib.is_mouse_button_down Raylib.MouseButton.Left in
      
      if total > 0 && mouse_now_pressed && not !mouse_pressed_prev then (
        if in_rect mx my prev_x prev_y ui_button_w ui_button_h then
          selected := max 0 (!selected - 1)
        else if in_rect mx my next_x next_y ui_button_w ui_button_h then
          selected := min (total - 1) (!selected + 1)
      );
      
      mouse_pressed_prev := mouse_now_pressed;

      Raylib.begin_drawing ();
      Raylib.clear_background Color.raywhite;

      if total > 0 then (
        let snap = snapshots_arr.(!selected) in
        let w = effective_width () in
        let h = effective_length () in
        let cell_w = grid_cell_w () in
        let cell_h = grid_cell_h () in
        for row = 0 to h - 1 do
          for col = 0 to w - 1 do
            let idx = (row * w) + col in
            let is_alive_cell =
              idx >= 0 && idx < Array.length snap && snap.(idx)
            in
            let x = float_of_int col *. cell_w in
            let y = float_of_int row *. cell_h in
            let pos = Vector2.create x y in
            let size = Vector2.create cell_w cell_h in
            if is_alive_cell then
              Raylib.draw_rectangle_v pos size Color.black
            else Raylib.draw_rectangle_v pos size Color.red;
            Raylib.draw_rectangle_lines
              (int_of_float x) (int_of_float y)
              (int_of_float cell_w) (int_of_float cell_h) Color.blue
          done
        done);

      Raylib.draw_rectangle prev_x prev_y ui_button_w ui_button_h Color.gray;
      Raylib.draw_rectangle_lines prev_x prev_y ui_button_w ui_button_h Color.blue;
      Raylib.draw_text "Prev" (prev_x + 20) (prev_y + 10) ui_font_size Color.black;

      Raylib.draw_rectangle next_x next_y ui_button_w ui_button_h Color.gray;
      Raylib.draw_rectangle_lines next_x next_y ui_button_w ui_button_h Color.blue;
      Raylib.draw_text "Next" (next_x + 15) (next_y + 10) ui_font_size Color.black;

      if total > 0 then
        Raylib.draw_text
          (Printf.sprintf "%d/%d" (!selected + 1) total)
          (next_x + ui_button_w + ui_button_margin) (next_y + 10) 18 Color.black
      else Raylib.draw_text "No snapshots" (prev_x) (prev_y + ui_button_h + 10) 18
        Color.black;

      Raylib.end_drawing ();
    done;

    Raylib.close_window ();
    Ok ()

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
      ("sleep", Extern_func (i32 ^->. unit, sleep));
      (* l'affichage logique *)
      ("cell_print", Extern_func (i32 ^->. unit, cell_print));
      (* pour le debug *)
      ("debogue_index", Extern_func (i32 ^->. unit, debogue_index));
      ("debogue_valeur", Extern_func (i32 ^->. unit, debogue_valeur));
      ("get_steps", Extern_func (unit ^->. i32, get_steps));
      ("get_last", Extern_func (unit ^->. i32, get_last));
      ("config_not_null", Extern_func (unit ^->. i32, config_not_null));
      ("get_width", Extern_func (unit ^->. i32, get_width));
      ("get_length", Extern_func (unit ^->. i32, get_length));
      ("get_alive", Extern_func (i32 ^-> i32 ^->. i32, get_alive));
      (* pour la saisie utilisateur *)
      ("read_int", Extern_func (unit ^->. i32, read_int));
      (*  *)
      ("open_window" , Extern_func(unit ^->. unit, open_window));
      ("close_window" , Extern_func(unit ^->. unit, close_window));
      ("is_close" , Extern_func(unit ^->. i32, is_close));
      ("end_drawing" , Extern_func(unit ^->. unit, end_drawing));
      ("begin_drawing" , Extern_func(unit ^->. unit, begin_drawing));
      ("clear_background" , Extern_func(unit ^->. unit, clear_background));
      ("cell_print_inter", Extern_func(i32 ^-> i32 ^-> i32 ^->. unit, cell_print_inter));
      ("run_ui", Extern_func(unit ^->. unit, run_ui));
      ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }