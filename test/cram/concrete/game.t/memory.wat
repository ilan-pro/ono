(module
  (func $print_cell (import "ono" "print_cell") (param i32))
  (func $print_grille
    (local $i i32)
    (local $j i32)

    (call $clear_screen)

    (local.set $i (i32.const 0))

    (block $stop_i
        (loop $loop_i
      
        (i32.eq (local.get $i) (global.get $longueur))
        (br_if $stop_i)

        (local.set $j (i32.const 0))

        (block $stop_j
            (loop $loop_j
        
            (i32.eq (local.get $j) (global.get $largeur))
            (br_if $stop_j)

            (call $print_cell
                (call $get_2d
                (local.get $i)
                (local.get $j)
                )
            )

            (local.set $j
                (i32.add (local.get $j) (i32.const 1))
            )

            (br $loop_j)
            )
        )

        (call $newline)

        (local.set $i
            (i32.add (local.get $i) (i32.const 1))
        )

        (br $loop_i)
        )

    )