(module
  (func $i32_symbol (import "ono" "i32_symbol") (result i32))
  (func $print_i32  (import "ono" "print_i32") (param i32))

  (func $main
    (local $n i32)
    (local $n2 i32)
    (local $n3 i32)

    call $i32_symbol
    local.tee $n
    i32.const 42
    i32.ne

    call $i32_symbol
    local.tee $n2
    i32.const 42
    i32.ne


    i32.or


    local.get $n 
    local.get $n2 
    i32.lt_u


    i32.or


    call $i32_symbol
    local.tee $n3
    i32.const 42
    i32.ne


    i32.or 


    local.get $n2 
    local.get $n3 
    i32.lt_u


    i32.or 
  

    ;; (if (then
    ;;   ;; return
    ;; )(else
    ;;   ;; unreachable
    ;;   ;; unreachable
    ;; ))

    unreachable
  )
  (start $main)
)