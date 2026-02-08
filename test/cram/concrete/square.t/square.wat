(module
    (func $print_i32 (import "ono" "print_i32") (param i32))
    (func $square (param $n i32) (result i32)
        local.get $n
        local.get $n
        i32.mul
    )

    (func $main
        i32.const 10
        call $square
        call $print_i32
    )

    (start $main)
)