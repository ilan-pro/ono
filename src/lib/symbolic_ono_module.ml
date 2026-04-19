type extern_func = Kdo.Symbolic.Extern_func.extern_func

let print_i32 (n : Kdo.Symbolic.I32.t) : unit Kdo.Symbolic.Choice.t =
  Logs.app (fun m -> m "%a" Kdo.Symbolic.I32.pp n);
  Kdo.Symbolic.Choice.return ()

let i32_symbol () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.with_new_symbol (Smtml.Ty.Ty_bitv 32)
    Kdo.Symbolic.I32.symbol

let polynome (num_lettre : Kdo.Symbolic.I32.t) : Kdo.Symbolic.I32.t =
  let res = Kdo.Symbolic.I32.to_int num_lettre in
  if res == 0 then print_string "Rentrez une valeur pour a"
  else if res == 1 then print_string "Rentrez une valeur pour b"
  else if res == 2 then print_string "Rentrez une valeur pour c"
  else print_string "Rentrez une valeur pour d";
  flush stdout;
  read_int ()

let m =
  let open Kdo.Symbolic.Extern_func in
  let open Kdo.Symbolic.Extern_func.Syntax in
  let functions =
    [
      ("print_i32", Extern_func (i32 ^->. unit, print_i32));
      ("i32_symbol", Extern_func (unit ^->. i32, i32_symbol));
      ("polynome", Extern_func (i32 ^->. i32, polynome));
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Symbolic.Extern_func.extern_type;
  }
