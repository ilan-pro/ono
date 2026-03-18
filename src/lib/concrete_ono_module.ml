open Concrete_config

type extern_func = Kdo.Concrete.Extern_func.extern_func

let buffer = Buffer.create 4096

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
  Buffer.add_char buffer '\n';
  Ok ()

let clear_screen () : (unit, _) Result.t =
  (* Format.printf "\027[2J"; *)
  Buffer.output_buffer stdout buffer;
  flush stdout;
  Buffer.clear buffer;
  Ok ()

let random_i32 (n : Kdo.Concrete.I32.t) : (Kdo.Concrete.I32.t, _) Result.t =
  (* La fonction prend un paramètre n et retourne un nombre aléatoire entre 0 et n-1 *)
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
  Unix.sleep (Kdo.Concrete.I32.to_int x);
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
  print_string "Entrez une valeur : ";
  flush stdout;
  let n = Scanf.scanf " %d" (fun x -> x) in
  Ok (Kdo.Concrete.I32.of_int n)

  open Raylib
  (* open Tsdl *)
  let open_window () : (unit,_) Result.t =
     init_window 800 800 "Game of life";
    Ok()

  
  let close_window () : (unit,_) Result.t =
    close_window();
    Ok() 

  let is_close () : (Kdo.Concrete.I32.t,_) Result.t =
    let b = if window_should_close() then 0 else 1 in
    Ok(Kdo.Concrete.I32.of_int b)

  let begin_drawing () : (unit,_) Result.t =
    begin_drawing();
    Ok()
  
  let end_drawing () : (unit,_) Result.t =
    end_drawing();
    Ok() 
  
  let clear_background () : (unit,_) Result.t =
    clear_background Color.raywhite;
    Ok()

  let cell_print_inter (is_alive : Kdo.Concrete.I32.t) (row : Kdo.Concrete.I32.t) (column : Kdo.Concrete.I32.t) : (unit, _) Result.t =
      let size = Vector2.create 200.0 200.0 in
      let x = float_of_int (Kdo.Concrete.I32.to_int column * 200) in
      let y = float_of_int (Kdo.Concrete.I32.to_int row * 200) in
      let pos = Vector2.create x y in
      if is_alive <> Kdo.Concrete.I32.of_int 0 then (
        draw_rectangle_v pos size Color.black;
        draw_rectangle_lines (Kdo.Concrete.I32.to_int column * 200) (Kdo.Concrete.I32.to_int row * 200) 200 200 Color.blue
      )
      else (
        draw_rectangle_v pos size Color.red;
        draw_rectangle_lines (Kdo.Concrete.I32.to_int column * 200) (Kdo.Concrete.I32.to_int row * 200) 200 200 Color.blue
      );
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
      ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }
