type extern_func = Kdo.Symbolic.Extern_func.extern_func

let print_i32 (n : Kdo.Symbolic.I32.t) : unit Kdo.Symbolic.Choice.t =
  Logs.app (fun m -> m "%a" Kdo.Symbolic.I32.pp n);
  Kdo.Symbolic.Choice.return ()

let i32_symbol () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.with_new_symbol (Smtml.Ty.Ty_bitv 32)
    Kdo.Symbolic.I32.symbol

let read_int () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  let n = Scanf.scanf " %d" (fun x -> x) in
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int n)

let polynomeA () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  (* let res = Kdo.Symbolic.I32.of_int num_lettre in *)
  (* if res == 0 then print_string "Rentrez une valeur pour a"
  else if res == 1 then print_string "Rentrez une valeur pour b"
  else if res == 2 then print_string "Rentrez une valeur pour c"
  else print_string "Rentrez une valeur pour d"; *)
  print_string "Rentrez une valeur pour A : ";
  flush stdout;
  read_int ()

let polynomeB () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  (* let res = Kdo.Symbolic.I32.of_int num_lettre in *)
  (* if res == 0 then print_string "Rentrez une valeur pour a"
  else if res == 1 then print_string "Rentrez une valeur pour b"
  else if res == 2 then print_string "Rentrez une valeur pour c"
  else print_string "Rentrez une valeur pour d"; *)
  print_string "Rentrez une valeur pour B : ";
  flush stdout;
  read_int ()

let polynomeC () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  (* let res = Kdo.Symbolic.I32.of_int num_lettre in *)
  (* if res == 0 then print_string "Rentrez une valeur pour a"
  else if res == 1 then print_string "Rentrez une valeur pour b"
  else if res == 2 then print_string "Rentrez une valeur pour c"
  else print_string "Rentrez une valeur pour d"; *)
  print_string "Rentrez une valeur pour C: ";
  flush stdout;
  read_int ()

let polynomeD () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  (* let res = Kdo.Symbolic.I32.of_int num_lettre in *)
  (* if res == 0 then print_string "Rentrez une valeur pour a"
  else if res == 1 then print_string "Rentrez une valeur pour b"
  else if res == 2 then print_string "Rentrez une valeur pour c"
  else print_string "Rentrez une valeur pour d"; *)
  print_string "Rentrez une valeur pour D: ";
  flush stdout;
  read_int ()

let debug () : unit Owi.Symbolic_choice.t =
  print_string "jsuis là\n";
  Kdo.Symbolic.Choice.return ()

let m =
  let open Kdo.Symbolic.Extern_func in
  let open Kdo.Symbolic.Extern_func.Syntax in
  let functions =
    [
      ("print_i32", Extern_func (i32 ^->. unit, print_i32));
      ("i32_symbol", Extern_func (unit ^->. i32, i32_symbol));
      ("read_int", Extern_func (unit ^->. i32, read_int));
      ("polynomeA", Extern_func (unit ^->. i32, polynomeA));
      ("polynomeB", Extern_func (unit ^->. i32, polynomeB));
      ("polynomeC", Extern_func (unit ^->. i32, polynomeC));
      ("polynomeD", Extern_func (unit ^->. i32, polynomeD));
      ("debug", Extern_func (unit ^->. unit, debug));
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Symbolic.Extern_func.extern_type;
  }
