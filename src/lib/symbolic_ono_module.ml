type extern_func = Kdo.Symbolic.Extern_func.extern_func

let width = ref None
let length = ref None

let print_i32 (n : Kdo.Symbolic.I32.t) : unit Kdo.Symbolic.Choice.t =
  Logs.app (fun m -> m "%a" Kdo.Symbolic.I32.pp n);
  Kdo.Symbolic.Choice.return ()

let i32_symbol () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.with_new_symbol (Smtml.Ty.Ty_bitv 32)
    Kdo.Symbolic.I32.symbol

let read_int () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  let n = Scanf.scanf " %d" (fun x -> x) in
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int n)

let read () : int = Scanf.scanf " %d" (fun x -> x)

let polynomeA () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  print_string "Rentrez une valeur pour A : ";
  flush stdout;
  read_int ()

let polynomeB () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  print_string "Rentrez une valeur pour B : ";
  flush stdout;
  read_int ()

let polynomeC () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  print_string "Rentrez une valeur pour C: ";
  flush stdout;
  read_int ()

let polynomeD () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  print_string "Rentrez une valeur pour D: ";
  flush stdout;
  read_int ()

let config_symb = ref 0
let set_config_symb n = config_symb := n

let get_config_symb () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  if !config_symb < 0 then failwith "Any constraint found"
  else Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int !config_symb)

let setX () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  print_string "Rentrez une valeur pour x : ";
  flush stdout;
  read_int ()

let getN () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  print_string "Rentrez une valeur pour N : ";
  flush stdout;
  read_int ()

let setY () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  print_string "Rentrez une valeur pour y : ";
  flush stdout;
  read_int ()

(* nous allons initialiser la largeur et la longueur en demandant à l'utilisateur puis nous allons set une variable partagé via l'interface 
`symbolic_config` *)

let init_config_symbolic () : unit Owi.Symbolic_choice.t =
  print_string "Rentrez une largeur pour la grille : ";
  flush stdout;
  let largeur = read () in
  width := Some largeur;

  print_string "Rentrez une longueur pour la grille : ";
  flush stdout;
  let longueur = read () in
  length := Some longueur;

  (* pour avoir le bon chemin pour y stocker le fichier *)
  let path = "config/symbolic_dimension.json" in

  (* écrire dans un fichier txt width et length ou dans un json !! *)
  let json =
    `Assoc [ ("largeur", `Int largeur); ("longueur", `Int longueur) ]
  in

  Yojson.Safe.to_file path json;

  Kdo.Symbolic.Choice.return ()

let get_width () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  match !width with
  | None -> Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int 0)
  | Some x -> Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int x)

let get_length () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  match !length with
  | None -> Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int 0)
  | Some x -> Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int x)

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
      ("get_config_symb", Extern_func (unit ^->. i32, get_config_symb));
      ("setX", Extern_func (unit ^->. i32, setX));
      ("getN", Extern_func (unit ^->. i32, getN));
      ("setY", Extern_func (unit ^->. i32, setY));
      (* pour la saisie utilisateur *)
      ( "init_config_symbolic",
        Extern_func (unit ^->. unit, init_config_symbolic) );
      ("get_width", Extern_func (unit ^->. i32, get_width));
      ("get_length", Extern_func (unit ^->. i32, get_length));
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Symbolic.Extern_func.extern_type;
  }
