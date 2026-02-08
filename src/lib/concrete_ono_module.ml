type extern_func = Kdo.Concrete.Extern_func.extern_func

let print_i32 (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

let print_i64 (n : Kdo.Concrete.I64.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I64.pp n);
  Ok ()

let random_i32 (n : Kdo.Concrete.I32.t) : (Kdo.Concrete.I32.t, _) Result.t =
  Ok (Kdo.Concrete.I32.of_int (Random.int (Kdo.Concrete.I32.to_int n)))

let m =
  let open Kdo.Concrete.Extern_func in
  let open Kdo.Concrete.Extern_func.Syntax in
  let functions = [ 
    ("print_i32", Extern_func (i32 ^->. unit, print_i32));
    ("print_i64", Extern_func (i64 ^->. unit, print_i64));
    ("random_i32", Extern_func (i32 ^->. i32, random_i32))
    ] in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }