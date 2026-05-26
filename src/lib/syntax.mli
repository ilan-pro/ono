(** Helpers [result] pour enchaîner les étapes du driver. *)

val ( let* ) : ('a, 'e) result -> ('a -> ('b, 'e) result) -> ('b, 'e) result
val ( let+ ) : ('a, 'e) result -> ('a -> 'b) -> ('b, 'e) result
