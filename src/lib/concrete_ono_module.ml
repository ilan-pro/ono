type extern_func = Kdo.Concrete.Extern_func.extern_func

let buffer = Buffer.create 4096

let print_i32 (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

let print_i64 (n : Kdo.Concrete.I64.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I64.pp n);
  Ok ()

let print_cell (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  let alive = Owi.Concrete_boolean.to_bool (Kdo.Concrete.I32.gt n Kdo.Concrete.I32.zero) in
  Buffer.add_string buffer (if alive then "🦊" else " ");
  Ok ()

let newline () : (unit, _) Result.t =
  Buffer.add_char buffer '\n';
  Ok ()

let clear_screen () : (unit, _) Result.t =
  Format.printf "\027[2J";
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

let m =
  let open Kdo.Concrete.Extern_func in
  let open Kdo.Concrete.Extern_func.Syntax in
  let functions =
    [
      ("print_i32", Extern_func (i32 ^->. unit, print_i32));
      ("print_i64", Extern_func (i64 ^->. unit, print_i64));
      ("random_i32", Extern_func (i32 ^->. i32, random_i32));
      ("print_cell", Extern_func (i32 ^->. unit, print_cell));
      ("newline", Extern_func (unit ^->. unit, newline));
      ("clear_screen", Extern_func (unit ^->. unit, clear_screen));
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }