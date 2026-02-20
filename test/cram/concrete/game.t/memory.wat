(module
    (import "ono" "random_i32" (func $random_i32 (param i32) (result i32)))
    (import "ono" "print_cell" (func $print_cell (param i32)))
    (import "ono" "newline" (func $newline))
    (import "ono" "clear_screen" (func $clear_screen))

    (global $largeur i32 (i32.const 6))
    (global $longueur i32 (i32.const 9))
    (memory 10) ;; taille arbitrairement grande (10 pages ~ 650 000 octets et un i32 c'est 4*8 bits donc on est large)

    (func $addr_2d (param $i i32) (param $j i32) (result i32)
        local.get $i
        global.get $largeur
        i32.mul
        local.get $j
        i32.add
        i32.const 4
        i32.mul)

    (func $init
        (local $size i32)
        (local $ptr i32)

        global.get $largeur 
        global.get $longueur 
        i32.mul
        local.set $size

        (block $remplissage ;; on la remplit (TODO mette les valeurs aléatoire via random_I32)
            (loop $loop
                ;; if n == 0 then void
                (i32.eq (local.get $size) (i32.const 0))
                br_if $remplissage

                ;; n-1
                (i32.sub (local.get $size) (i32.const 1))
                local.set $size

                ;; memory[i] = 0
                local.get $ptr
                i32.const 0
                i32.store 

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
        i32.const 4
        i32.mul
        i32.load ;; memory [i][j]
    )

    (func $set_2d (param $i i32) (param $j i32) (param $v i32)
        local.get $i
        local.get $j
        call $in_bounds
        i32.eqz
        if
            return
        end
        local.get $i
        local.get $j
        call $addr_2d
        local.get $v
        i32.store)

    (func $in_bounds (param $i i32) (param $j i32) (result i32)
        local.get $j
        i32.const 0
        i32.lt_s
        local.get $j
        global.get $largeur
        i32.ge_s
        i32.or

        local.get $i
        i32.const 0
        i32.lt_s
        local.get $i
        global.get $longueur
        i32.ge_s
        i32.or
        i32.or

        i32.eqz)

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

    (func $step (export "step")
        (local $i i32)
        (local $j i32)
        (local $cell i32)
        (local $n i32)
        (local $live i32)
        (local $r i32)

        i32.const 0
        local.set $i
        (block $done_i
            (loop $loop_i
                i32.const 0
                local.set $j
                (block $done_j
                    (loop $loop_j
                        local.get $i
                        local.get $j
                        call $get_2d
                        local.set $cell

                        local.get $i
                        local.get $j
                        call $count_neighboors
                        local.get $cell
                        i32.sub
                        local.set $n

                        local.get $cell
                        if (result i32)
                            local.get $n
                            i32.const 2
                            i32.eq
                            local.get $n
                            i32.const 3
                            i32.eq
                            i32.or
                        else
                            local.get $n
                            i32.const 3
                            i32.eq
                        end
                        local.set $live

                        i32.const 10000
                        call $random_i32
                        local.set $r
                        local.get $live
                        local.get $r
                        i32.eqz
                        i32.or
                        local.set $live

                        local.get $i
                        local.get $j
                        local.get $live
                        call $set_2d

                        local.get $j
                        i32.const 1
                        i32.add
                        local.tee $j
                        global.get $largeur
                        i32.lt_s
                        br_if $loop_j
                    )
                )

                local.get $i
                i32.const 1
                i32.add
                local.tee $i
                global.get $longueur
                i32.lt_s
                br_if $loop_i
            )
        ))

    (func $print_grid (export "print_grid")
    )

    (;
    Affiche la grille dans le terminal via des fonctions hôtes OCaml.

    Principe :
    - On parcourt toutes les cellules (i = lignes, j = colonnes)
    - On lit l'état (0/1) avec get_2d
    - On appelle print_cell(value) : côté OCaml, ça ajoute "🦊" ou " " dans un Buffer
    - A la fin de chaque ligne : newline()
    - A la fin : clear_screen() flush le Buffer vers stdout, puis le vide

    (func $print_grid (export "print_grid")
        (local $i i32)
        (local $j i32)

        ;; i = 0
        i32.const 0
        local.set $i
        (block $done_i
            (loop $loop_i
                ;; j = 0
                i32.const 0
                local.set $j
                (block $done_j
                    (loop $loop_j
                        ;; print_cell( get_2d(i, j) )
                        local.get $i
                        local.get $j
                        call $get_2d
                        call $print_cell

                        ;; j++ ; si j < largeur => continue la ligne
                        local.get $j
                        i32.const 1
                        i32.add
                        local.tee $j
                        global.get $largeur
                        i32.lt_s
                        br_if $loop_j
                    )
                )

                ;; fin de ligne : newline()
                call $newline

                ;; i++ ; si i < longueur => continue les lignes
                local.get $i
                i32.const 1
                i32.add
                local.tee $i
                global.get $longueur
                i32.lt_s
                br_if $loop_i
            )
        )

        ;; petite ligne vide après la grille
        call $newline
        ;; flush du buffer + clear terminal
        call $clear_screen
    )
    ;)

    (func $main (export "_start")
        call $step)

    (start $init)
)