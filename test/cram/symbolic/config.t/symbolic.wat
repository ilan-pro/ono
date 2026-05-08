(module
    (func $i32_symbol (import "ono" "i32_symbol") (result i32))
    (func $print_i32 (import "ono" "print_i32") (param i32))

    (global $largeur (mut i32) (i32.const 4))
    (global $longueur (mut i32) (i32.const 4))
    (memory 1)

    (func $init_mem 
        (local $size i32) 
        (local $tmp_x i32)
        (local $ptr i32)    

        global.get $largeur 
        global.get $longueur 
        i32.mul
        local.set $size
        (local.set $ptr (i32.const 0))
        
        (block $remplissage
            (loop $loop


                ;; si size == 0 break
                (i32.eq (local.get $size) (i32.const 0))
                br_if $remplissage

                call $i32_symbol local.set $tmp_x

                ;; n-1
                (i32.sub (local.get $size) (i32.const 1))
                local.set $size

                ;; on stocke le x dans la mémoire temporaire *ptr = tmp_x
                local.get $ptr
                local.get $tmp_x
                i32.store  

                ;; ptr++
                local.get $ptr
                i32.const 4 ;; on stock un i32 sur 4 octets et comme 
                i32.add
                local.set $ptr

                br $loop
            )
        )
    )

    (func $all
        ;; (local $size i32) 
        ;; (local $tmp_x i32)
        ;; (local $ptr i32)    

        ;; global.get $largeur 
        ;; global.get $longueur 
        ;; i32.mul
        ;; local.set $size
        ;; (local.set $ptr (i32.const 0))

        ;; (block $remplissage
        ;;     (loop $loop

        ;;         ;; si size == 0 break
        ;;         (i32.eq (local.get $size) (i32.const 0))
        ;;         br_if $remplissage

        ;;         ;; n-1
        ;;         (i32.sub (local.get $size) (i32.const 1))
        ;;         local.set $size

        ;;         ;; on ajoute à la pile le x de la mémoire linéaire
        ;;         local.get $ptr

        ;;         ;; ptr++
        ;;         local.get $ptr
        ;;         i32.const 4 ;; on stock un i32 sur 4 octets et comme 
        ;;         i32.add
        ;;         local.set $ptr

        ;;         br $loop
        ;;     )
        ;; )

        unreachable
    )

    (func $main
        call $init_mem
        call $all
        i32.const 344
        call $print_i32
    )

    (start $main)
)