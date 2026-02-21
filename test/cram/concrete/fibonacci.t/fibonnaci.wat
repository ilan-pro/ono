(module
  (func $print_i32 (import "ono" "print_i32") (param i32))
  (func $f (param $n i32) (result i32)

    (if
      (i32.lt_s
        (local.get $n)
        (i32.const 2))
      (then (return (local.get $n))))
    (return
      (i32.add
        (call $f
          (i32.sub
            (local.get $n)
            (i32.const 2)))
        (call $f
          (i32.sub
            (local.get $n)
            (i32.const 1)))
      )
    )
  )
)


  )






  (func $main
    i32.const 10
    call $f
    call $print_i32
  )
  (start $main)
)
