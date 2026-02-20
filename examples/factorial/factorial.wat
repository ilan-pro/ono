(module
  ;; Import de la fonction print_i32 depuis OCaml
  (import "ono" "print_i32" (func $print_i32 (param i32)))

  ;; Fonction récursive pour calculer la factorielle
  (func $factorial (param $n i32) (result i32)
    (if (result i32)
      (i32.le_s (local.get $n) (i32.const 1))
      (then
        (i32.const 1)
      )
      (else
        (i32.mul
          (local.get $n)
          (call $factorial
            (i32.sub (local.get $n) (i32.const 1))
          )
        )
      )
    )
  )

  ;; Fonction main
  (func $main
    (call $print_i32
      (call $factorial (i32.const 5))
    )
  )

  (export "_start" (func $main))
)
