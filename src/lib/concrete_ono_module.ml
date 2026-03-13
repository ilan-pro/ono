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
      ("config_not_null", Extern_func (unit ^->. i32, config_not_null));
      ("get_width", Extern_func (unit ^->. i32, get_width));
      ("get_length", Extern_func (unit ^->. i32, get_length));
      ("get_alive", Extern_func (i32 ^-> i32 ^->. i32, get_alive));
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }
