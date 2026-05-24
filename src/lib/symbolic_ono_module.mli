(** Module hôte [ono] pour l'interpréteur symbolique. *)

type extern_func = Kdo.Symbolic.Extern_func.extern_func

val m : extern_func Kdo.Extern.Module.t
(** Fonctions importées par les fichiers [.wat] symboliques. *)

val set_config_symb : int -> unit
(** Numéro de contrainte choisi sur la ligne de commande. *)
