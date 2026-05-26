(** Parsing des fichiers JSON de configuration du jeu de la vie. *)

type config = { width : int; length : int; alive : (int * int) list }
(** Type représentant la configuration du jeu de la vie, nous devons faire
    correspondre les fichiers pris en argument de la cli à ce type si nous
    voulons garantir la compatibilité *)

val global_config : config option ref
(** Référence vers la configuration globale *)

val parse_config : Yojson.Safe.t -> config
(** Fonction de parsing afin de parser un fichier de configuration json fournit
    en argument et produire une configuration lisible par notre moteur ono*)

val parse_json_to_symbolic : Yojson.Safe.t -> Yojson.Safe.t -> config
(** Fonction de parsing d'un fichier json représentant des objets symboliques
    (symbole_i32) fournit en argument afin de produire une configuration lisible
    par notre moteur ono *)
