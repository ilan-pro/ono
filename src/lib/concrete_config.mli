(* c'est plus logique de faire le travail de parsing et de construction dans le driver 
car c'est ici qu'il y a la logique de parsing et d'execution. *)
type config = { width : int; length : int; alive : (int * int) list }

(* référence vers la configuration globale *)
val global_config : config option ref
val parse_config : Yojson.Safe.t -> config
val parse_json_to_symbolic : Yojson.Safe.t -> Yojson.Safe.t -> config