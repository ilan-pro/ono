(module
  (import "ono" "print_i64" (func $print_i64 (param i64)))

  (func $square_i64 (param $n i64) (result i64)
    (i64.mul (local.get $n) (local.get $n))
  )

  (func $main
    (call $print_i64
      (call $square_i64 (i64.const 50000))
    )
  )

  (export "_start" (func $main))
)
