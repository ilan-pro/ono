(** Module hôte [ono] pour l'interpréteur concret. *)

type extern_func = Kdo.Concrete.Extern_func.extern_func

val m : extern_func Kdo.Extern.Module.t
(** Fonctions importées par les fichiers [.wat] (print, random, jeu de la vie, raylib). *)

val set_steps_arg : int -> unit
(** Nombre max d'itérations ([0] = illimité). *)

val set_last_arg : int -> unit
(** Nombre d'itérations finales à afficher. *)

val set_test : int -> unit
(** Mode cram test (dimensions fixes). *)

val set_option_graphic : int -> unit
(** [0] terminal, [1] fenêtre graphique. *)
