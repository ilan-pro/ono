(module

    (func $clear_screen (import "ono" "clear_screen"))
    (func $newline (import "ono" "newline"))
    (func $cell_print (import "ono" "cell_print") (param i32))
    (func $print_i32 (import "ono" "print_i32") (param i32))
    (func $random_i32 (import "ono" "random_i32") (param i32) (result i32))


    (global $largeur i32 (i32.const 20))
    (global $longueur i32 (i32.const 20))
    (memory 10) ;; taille arbitrairement grande (10 pages ~ 650 000 octets et un i32 c'est 4*8 bits donc on est large)

    (func $init
        (local $size i32) 
        (local $ptr i32)
        (local $rand i32)

        global.get $largeur 
        global.get $longueur 
        i32.mul
        (local.set $size)
        (local.set $ptr (i32.const 0))
        
       

        (block $remplissage ;; on la remplit (TODO mette les valeurs aléatoire via random_I32)
            (loop $loop
                ;; if n == 0 then void
                (i32.eq (local.get $size) (i32.const 0))
                br_if $remplissage

                ;; n-1
                (i32.sub (local.get $size) (i32.const 1))
                local.set $size

                ;; memory[i] = 0
                
                i32.const 100
                call $random_i32
                i32.const 98
                i32.gt_u

                (if (then
                    local.get $ptr
                    i32.const 1
                    i32.store )
                (else
                    local.get $ptr
                    i32.const 0
                    i32.store
                    )
                )

                ;; i++
                local.get $ptr
                i32.const 4 ;; on stock un i32 sur 4 octets et comme 
                i32.add
                local.set $ptr

                br $loop
            )
        )
    )

    (func $get_2d (param $i i32) (param $j i32) (result i32)
        ;; on vérifie avant si on est pas hors limite
        local.get $j ;; numéro de la colonne 
        i32.const 0
        i32.lt_s ;; j<0
        local.get $j 
        global.get $largeur
        i32.ge_s ;; (greater or equal)
        i32.or 
        
        local.get $i ;; numéro de la ligne
        i32.const 0
        i32.lt_s ;; i<0
        local.get $i
        global.get $longueur
        i32.ge_s 
        i32.or
        i32.or ;; pour (j<0 OR j>= largeur OR i<0 OR i>=longueur)

        (if (then
            i32.const 0
            return 
        ))

        local.get $j
        local.get $i
        global.get $largeur ;; j'ajoute la taille d'une colonne dans la pile afin de pouvoir multiplier la position de la ligne  
        i32.mul
        i32.add
        i32.const 4 ;; chaque i32 prends 4 octets mais il faut soustraire pour revenir au début de [i][j] donc -4
        i32.mul
        i32.load ;; memory [i][j]
    )

    (func $get_1d (param $posi i32) (result i32)
        local.get $posi
        i32.const 4
        i32.mul ;; il faut multiplier par 4 car un i32 c'est 4 octets
        i32.load ;; memory[posi]
    )

    ;; si nous gardons le fait que nous avons un tableau de 0 et 1 nous n'avons pas de vérifier si la valeur
    ;; que nous venons de prendre est 0 ou 1 mais juste de faire l'addition et cela nous donnera le nombre de voisin 
    ;; de la case [i][j]
    (func $count_neighboors (param $i i32) (param $j i32) (result i32)
        (local $nb_neighboors i32)
        (local $i_m1 i32) ;; i-1
        (local $i_p1 i32) ;; i+1
        (local $j_m1 i32) ;; j-1
        (local $n i32)
        
        ;; nous initialisons les variables locales donc aucune valeur sur la pile pour le moment
        (i32.sub (local.get $i) (i32.const 1))
        local.set $i_m1
        (i32.add (local.get $i) (i32.const 1))
        local.set $i_p1 
        (i32.sub (local.get $j) (i32.const 1))
        local.set $j_m1 
        
        ;; i-1
        local.get $j_m1
        local.set $n ;; n = j-1
        (block $i_1
            (loop $loop
                ;; si n == j+2 alors on arrête car on veut parcourir j-1 j j+1
                (i32.eq (local.get $n) (i32.add (local.get $j) (i32.const 2))) 
                br_if $i_1 

                local.get $n
                local.get $i_m1
                call $get_2d 
                local.get $nb_neighboors
                i32.add ;; nb_neighboors = memory[i-1][j-1] + nb_neighboors 
                local.set $nb_neighboors

                (i32.add (local.get $n) (i32.const 1)) ;; n++
                local.set $n
                br $loop
            )
        )
        
        ;; i
        local.get $j_m1
        local.set $n 
        (block $i_1
            (loop $loop
                (i32.eq (local.get $n) (i32.add (local.get $j) (i32.const 2))) 
                br_if $i_1 

                ;; ne pas faire de boucle pour i 
                local.get $n
                local.get $i
                call $get_2d 
                local.get $nb_neighboors
                i32.add 
                local.set $nb_neighboors

                (i32.add (local.get $n) (i32.const 1)) 
                local.set $n
                br $loop
            )
        )

        ;; i+1
        local.get $j_m1
        local.set $n 
        (block $i_1
            (loop $loop
                (i32.eq (local.get $n) (i32.add (local.get $j) (i32.const 2))) 
                br_if $i_1 

                local.get $n
                local.get $i_p1
                call $get_2d 
                local.get $nb_neighboors
                i32.add
                local.set $nb_neighboors

                (i32.add (local.get $n) (i32.const 1)) 
                local.set $n
                br $loop
            )
        )  

        local.get $nb_neighboors
    )

    (func $print_grid 
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

                (call $cell_print
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
    )

    ;; (func $step (export "step")
    ;;     (local $i i32)
    ;;     (local $j i32)
    ;;     (local $count i32)
    ;;     (local $cell_alive i32)
    ;;     (local $live i32)
    ;;     (local $r i32)

    ;;     i32.const 0
    ;;     local.set $i
    ;;     loop $loop_i_neigh
    ;;     i32.const 0
    ;;     local.set $j
    ;;     loop $loop_j_neigh
    ;;         local.get $i
    ;;         local.get $j
    ;;         call $count_neighboors
    ;;         local.set $count

    ;;         global.get $neigh_base
    ;;         local.get $i
    ;;         local.get $j
    ;;         call $idx
    ;;         i32.add
    ;;         local.get $count
    ;;         i32.store8

    ;;         local.get $j
    ;;         i32.const 1
    ;;         i32.add
    ;;         local.tee $j
    ;;         global.get $w
    ;;         i32.lt_s
    ;;         br_if $loop_j_neigh
    ;;     end

    ;;     local.get $i
    ;;     i32.const 1
    ;;     i32.add
    ;;     local.tee $i
    ;;     global.get $h
    ;;     i32.lt_s
    ;;     br_if $loop_i_neigh
    ;;     end

    ;;     i32.const 0
    ;;     local.set $i
    ;;     loop $loop_i_upd
    ;;     i32.const 0
    ;;     local.set $j
    ;;     loop $loop_j_upd
    ;;         local.get $i
    ;;         local.get $j
    ;;         call $is_alive
    ;;         local.set $cell_alive

    ;;         global.get $neigh_base
    ;;         local.get $i
    ;;         local.get $j
    ;;         call $idx
    ;;         i32.add
    ;;         i32.load8_u
    ;;         local.set $count

    ;;         local.get $cell_alive
    ;;         if (result i32)
    ;;         local.get $count
    ;;         i32.const 2
    ;;         i32.eq
    ;;         local.get $count
    ;;         i32.const 3
    ;;         i32.eq
    ;;         i32.or
    ;;         else
    ;;         local.get $count
    ;;         i32.const 3
    ;;         i32.eq
    ;;         end
    ;;         local.set $live

    ;;         i32.const 10000
    ;;         call $random_i32
    ;;         local.set $r

    ;;         local.get $live
    ;;         local.get $r
    ;;         i32.eqz
    ;;         i32.or
    ;;         local.set $live

    ;;         global.get $grid_base
    ;;         local.get $i
    ;;         local.get $j
    ;;         call $idx
    ;;         i32.add
    ;;         local.get $live
    ;;         i32.store8

    ;;         local.get $j
    ;;         i32.const 1
    ;;         i32.add
    ;;         local.tee $j
    ;;         global.get $w
    ;;         i32.lt_s
    ;;         br_if $loop_j_upd
    ;;     end

    ;;     local.get $i
    ;;     i32.const 1
    ;;     i32.add
    ;;     local.tee $i
    ;;     global.get $h
    ;;     i32.lt_s
    ;;     br_if $loop_i_upd
    ;;     end
    ;; )

    (func $main
        (local $i i32)
        
        call $init  
        
        i32.const 2
        local.set $i

        (block $stop
            (loop $loop

                (i32.eq (local.get $i) (i32.const 0))
                br_if $stop 

                call $print_grid
                (call $newline)

                (i32.sub (local.get $i) (i32.const 1))
                local.set $i

                br $loop
            )
        )

        ;; call $step
    )

    (start $main)
)
 

    