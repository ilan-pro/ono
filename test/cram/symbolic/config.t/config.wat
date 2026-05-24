(module
    (func $i32_symbol (import "ono" "i32_symbol") (result i32))
    (func $print_i32 (import "ono" "print_i32") (param i32))
    (func $init_config_symbolic (import "ono" "init_config_symbolic"))
    (func $get_width (import "ono" "get_width") (result i32))
    (func $get_length (import "ono" "get_length") (result i32))
    (func $setX (import "ono" "setX") (result i32))
    (func $setY (import "ono" "setY") (result i32))
    (func $get_config_symb (import "ono" "get_config_symb") (result i32))
    
    (global $largeur (mut i32) (i32.const 1))
    (global $longueur (mut i32) (i32.const 1))
    (memory 10)

    (func $init_dimension   
        call $init_config_symbolic
        (global.set $largeur (call $get_width))
        (global.set $longueur (call $get_length))
    )

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

                ;; call $i32_symbol local.set $tmp_x
                (call $i32_symbol)
                (i32.const 2)
                i32.rem_u
                local.set $tmp_x
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

    (func $count_alive (result i32)
        (local $nb_alive i32)
        (local $i i32) 
        (local $j i32)

        (local.set $i (i32.const 0))
        (local.set $nb_alive (i32.const 0))

        (block $stop_i
            (loop $loop_i
                (i32.eq (local.get $i) (global.get $longueur))
                (br_if $stop_i)
                (local.set $j (i32.const 0))

                (block $stop_j
                    (loop $loop_j
                
                    (i32.eq (local.get $j) (global.get $largeur))
                    (br_if $stop_j)

                    local.get $nb_alive
                    local.get $i
                    local.get $j
                    call $get_2d

                    i32.add
                    local.set $nb_alive

                    (local.set $j (i32.add (local.get $j) (i32.const 1)))
                    (br $loop_j)
                    )
                )

                (local.set $i (i32.add (local.get $i) (i32.const 1)))
                (br $loop_i)
                )
            )
        local.get $nb_alive
    )
        


    (func $get_2d (param $i i32) (param $j i32) (result i32)
        ;; on vérifie avant si on est pas hors limite
        (local $tmp_x i32)
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

    ;; Ecrit une valeur dans le buffer temporaire (adresse de base 2000)
    (func $set_tmp (param $i i32) (param $j i32) (param $v i32)
        local.get $j
        local.get $i
        global.get $largeur
        i32.mul
        i32.add
        i32.const 4
        i32.mul
        i32.const 100000  ;; offset du buffer temporaire
        i32.add
        local.get $v
        i32.store
    )

    ;; Recopie le buffer temporaire vers le buffer principal
    (func $copy_tmp
        (local $k i32)
        (local $addr i32)
        (local $val i32)

        i32.const 0
        local.set $k

        (block $done
            (loop $loop
                local.get $k
                global.get $largeur
                global.get $longueur
                i32.mul
                i32.ge_s
                br_if $done

                ;; addr = k * 4
                local.get $k
                i32.const 4
                i32.mul
                local.set $addr

                ;; val = memory[2000 + addr]
                local.get $addr
                i32.const 100000
                i32.add
                i32.load
                local.set $val

                ;; memory[addr] = val
                local.get $addr
                local.get $val
                i32.store

                ;; k++
                local.get $k
                i32.const 1
                i32.add
                ;; local.tee $k
                local.set $k
                br $loop
            )
        )
    )

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

                local.get $i_m1
                local.get $n
                call $get_2d 
                local.get $nb_neighboors
                i32.add ;; nb_neighboors = memory[i-1][j-1] + nb_neighboors 
                local.set $nb_neighboors

                (i32.add (local.get $n) (i32.const 1)) ;; n++
                local.set $n
                br $loop
            )
        )
        
        ;; i (on saute la cellule elle-meme : n != j)
        local.get $j_m1
        local.set $n 
        (block $i_1
            (loop $loop
                (i32.eq (local.get $n) (i32.add (local.get $j) (i32.const 2))) 
                br_if $i_1 

                ;; skip si n == j (c'est la cellule elle-meme)
                (block $skip
                    local.get $n
                    local.get $j
                    i32.eq
                    br_if $skip

                    local.get $i
                    local.get $n
                    call $get_2d 
                    local.get $nb_neighboors
                    i32.add 
                    local.set $nb_neighboors
                )

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

                local.get $i_p1
                local.get $n
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



    (func $step 
        (local $i i32)   
        (local $j i32)    
        (local $n i32)    ;; Nombre de voisins vivants
        (local $v i32)    ;; Nouvel état de la cellule

        i32.const 0
        local.set $i
        (block $done_i
            (loop $loop_i
                i32.const 0
                local.set $j
                (block $done_j
                    (loop $loop_j
                        ;; Compter les voisins de la cellule (i,j)
                        ;; Utilise la grille originale (pas le buffer temporaire)
                        local.get $i
                        local.get $j
                        call $count_neighboors
                        local.set $n

                        ;; Récupérer l'état actuel de la cellule
                        local.get $i
                        local.get $j
                        call $get_2d
                        local.set $v

                        local.get $n
                        i32.const 3
                        i32.eq


                        local.get $v
                        i32.const 1
                        i32.eq
                        
                        local.get $n
                        i32.const 2
                        i32.eq
                        
                        i32.and
                        i32.or
                        local.set $v

                        ;; ÉCRIRE dans le BUFFER TEMPO (adresse 2000+)
                        ;; Évite de modifier la grille pendant la lecture
                        local.get $i
                        local.get $j
                        local.get $v
                        call $set_tmp

                        ;; Prochaine colonne
                        ;; j++
                        local.get $j
                        i32.const 1
                        i32.add
                        local.tee $j
                        ;; if j < largeur
                        global.get $largeur
                        i32.lt_s
                        br_if $loop_j
                    )
                )

                ;; Prochaine ligne
                local.get $i
                i32.const 1
                i32.add
                local.tee $i
                global.get $longueur
                i32.lt_s
                br_if $loop_i
            )
        )
        call $copy_tmp
    )


    (func $contrainte_8
        (local $nb_alive i32)

        
        call $step
        call $count_alive
        (local.set $nb_alive)
        
        (i32.eq (local.get $nb_alive) (i32.const 4))
        (if 
            (then unreachable)
        )
    )


        (func $contrainte_5
        (local $nb_alive i32)

        
        call $step
        call $count_alive
        (local.set $nb_alive)
        
        (i32.eq (local.get $nb_alive) (i32.const 0))
        (if 
            (then unreachable)
        )
    )

    (func $contrainte_4
        (local $nb_alive i32)
        (local $c i32)
        
        
        call $step
        call $count_alive
        (local.set $nb_alive)
        
        global.get $largeur 
        global.get $longueur 
        i32.mul
        local.set $c

        (i32.eq (local.get $nb_alive) (local.get $c))
        (if 
            (then unreachable)
        )
    )


     ;; ;;    Au tour suivant, il y a au moins une cellule vivante sur la grille.
    (func $contrainte_3
        (local $nb_alive i32)

        call $step
        call $count_alive
        local.set $nb_alive

        (i32.gt_s (local.get $nb_alive) (i32.const 0))
        (if (then unreachable))    
    )

    ;; ;; Au tour suivant, la cellule en position (x,y) doit être vivante.
    (func $contrainte_1
        (local $x i32)
        (local $y i32)

        call $setX local.set $x
        call $setY local.set $y

        call $step
        local.get $x
        local.get $y
        call $get_2d
        (if (then unreachable))
    )
    ;; ;; Au tour suivant, la cellule en position (x,y) doit être morte.
     (func $contrainte_2
        (local $x i32)
        (local $y i32)

        call $setX local.set $x
        call $setY local.set $y

        call $step
        local.get $x
        local.get $y
        call $get_2d
        i32.eqz
        (if (then unreachable))
    )


    ;; ;; Au tour suivant, il existe un motif en "L" de trois cellules vivantes.
    (func $contrainte_12
        (local $i i32) 
        (local $j i32)


        (local.set $i (i32.const 0))

        call $step
        (block $stop_i
            (loop $loop_i
                (i32.eq (local.get $i) (global.get $longueur))
                (br_if $stop_i)
                (local.set $j (i32.const 0))

                (block $stop_j
                    (loop $loop_j
                
                    (i32.eq (local.get $j) (global.get $largeur))
                    (br_if $stop_j)

                    ;; pos i j doit être vivante
                    local.get $i
                    local.get $j
                    call $get_2d

                    ;; pos i-1  j doit être vivante
                    local.get $i
                    i32.const 1
                    i32.sub
                    local.get $j
                    call $get_2d

                    i32.and
                    ;; pos i j+1 doit être vivante
                    local.get $i
                    local.get $j
                    i32.const 1
                    i32.add
                    call $get_2d
                    i32.and

                    local.get $i
                    i32.const 1
                    i32.sub
                    local.get $j
                    i32.const 1
                    i32.add
                    call $get_2d
                    i32.eqz
                    i32.and                    

                    (if (then unreachable))


                    (local.set $j (i32.add (local.get $j) (i32.const 1)))
                    (br $loop_j)
                    )
                )

                (local.set $i (i32.add (local.get $i) (i32.const 1)))
                (br $loop_i)
                )
            )
    )

    ;; ;; Au tour suivant, il existe deux cellules vivantes côte à côte.
    (func $contrainte_11
        (local $i i32) 
        (local $j i32)


        (local.set $i (i32.const 0))

        call $step
        (block $stop_i
            (loop $loop_i
                (i32.eq (local.get $i) (global.get $longueur))
                (br_if $stop_i)
                (local.set $j (i32.const 0))

                (block $stop_j
                    (loop $loop_j
                
                    (i32.eq (local.get $j) (global.get $largeur))
                    (br_if $stop_j)


                    ;; pos i-1  j doit être vivante
                    local.get $i
                    i32.const 1
                    i32.sub
                    local.get $j
                    call $get_2d

                    ;; pos i+1  j doit être vivante
                    local.get $i
                    i32.const 1
                    i32.add
                    local.get $j
                    call $get_2d

                    i32.or

                    ;; pos i j+1 doit être vivante
                    local.get $i
                    local.get $j
                    i32.const 1
                    i32.add
                    call $get_2d

                    i32.or

                    ;; pos i j-1 doit être vivante
                    local.get $i
                    local.get $j
                    i32.const 1
                    i32.sub
                    call $get_2d

                    i32.or

                    ;; pos i j doit être vivante
                    local.get $i
                    local.get $j
                    call $get_2d

                    i32.and

                    (if (then unreachable))


                    (local.set $j (i32.add (local.get $j) (i32.const 1)))
                    (br $loop_j)
                    )
                )

                (local.set $i (i32.add (local.get $i) (i32.const 1)))
                (br $loop_i)
                )
            )
    )


    ;; ;; ;; Au tour suivant, il existe une cellule isolée (i.e. dont toutes les cellules voisines sont mortes).
    (func $contrainte_9
        (local $i i32) 
        (local $j i32)


        (local.set $i (i32.const 0))

        call $step
        (block $stop_i
            (loop $loop_i
                (i32.eq (local.get $i) (global.get $longueur))
                (br_if $stop_i)
                (local.set $j (i32.const 0))

                (block $stop_j
                    (loop $loop_j
                
                    (i32.eq (local.get $j) (global.get $largeur))
                    (br_if $stop_j)

                    ;; pos i j doit être vivante
                    local.get $i
                    local.get $j
                    call $get_2d

                    ;; et ses voisins sont morts
                    local.get $i
                    local.get $j
                    call $count_neighboors
                    i32.eqz
                    
                    i32.and

                    (if (then unreachable))

                    (local.set $j (i32.add (local.get $j) (i32.const 1)))
                    (br $loop_j)
                    )
                )

                (local.set $i (i32.add (local.get $i) (i32.const 1)))
                (br $loop_i)
                )
            )
    )

    ;; ;;Au tour suivant, il existe une cellule entourée de cellules vivantes.
     (func $contrainte_10
        (local $i i32) 
        (local $j i32)
        (local $voisin i32)

        (local.set $i (i32.const 0))
        (local.set $voisin (i32.const 0))

        call $step
        (block $stop_i
            (loop $loop_i
                (i32.eq (local.get $i) (global.get $longueur))
                (br_if $stop_i)
                (local.set $j (i32.const 0))

                (block $stop_j
                    (loop $loop_j
                
                    (i32.eq (local.get $j) (global.get $largeur))
                    (br_if $stop_j)

                    ;; pos i j doit être vivante
                    local.get $i
                    local.get $j
                    call $count_neighboors
                    local.set $voisin
                    
                    (i32.eq (local.get $voisin) (i32.const 8))

                    local.get $i
                    local.get $j
                    call $get_2d
                    i32.and

                    (if (then unreachable))

                    (local.set $j (i32.add (local.get $j) (i32.const 1)))
                    (br $loop_j)
                    )
                )

                (local.set $i (i32.add (local.get $i) (i32.const 1)))
                (br $loop_i)
                )
            )
    )


    ;; ;; Au tour suivant, il existe un motif carré de 2*2 cellules vivantes.
    (func $contrainte_13
        (local $i i32) 
        (local $j i32)


        (local.set $i (i32.const 0))

        call $step
        (block $stop_i
            (loop $loop_i
                (i32.eq (local.get $i) (global.get $longueur))
                (br_if $stop_i)
                (local.set $j (i32.const 0))

                (block $stop_j
                    (loop $loop_j
                
                    (i32.eq (local.get $j) (global.get $largeur))
                    (br_if $stop_j)

                    ;; 1er carré

                    ;; pos i j doit être vivante
                    local.get $i
                    local.get $j
                    call $get_2d
                    
                    ;; pos i-1 j+1 doit être vivante
                    local.get $i
                    i32.const 1
                    i32.sub
                    local.get $j
                    i32.const 1
                    i32.add
                    call $get_2d
                    i32.and

                    ;; pos i-1  j doit être vivante
                    local.get $i
                    i32.const 1
                    i32.sub
                    local.get $j
                    call $get_2d
                    i32.and

                    ;; pos i j+1 doit être vivante
                    local.get $i
                    local.get $j
                    i32.const 1
                    i32.add
                    call $get_2d
                    i32.and

                    ;; 2eme carré


                    ;; pos i j doit être vivante
                    local.get $i
                    local.get $j
                    call $get_2d

                    ;; pos i j+1 doit être vivante
                    local.get $i
                    local.get $j
                    i32.const 1
                    i32.add
                    call $get_2d
                    i32.and

                     ;; pos i+1  j doit être vivante
                    local.get $i
                    i32.const 1
                    i32.add
                    local.get $j
                    call $get_2d
                    i32.and
                    

                    ;; pos i+1 j+1 doit être vivante
                    local.get $i
                    i32.const 1
                    i32.add
                    local.get $j
                    i32.const 1
                    i32.add
                    call $get_2d
                    i32.and

                    i32.or

                    ;; 3eme carré

                    ;; pos i j doit être vivante
                    local.get $i
                    local.get $j
                    call $get_2d

                    ;; pos i+1  j doit être vivante
                    local.get $i
                    i32.const 1
                    i32.add
                    local.get $j
                    call $get_2d
                    i32.and
                    

                    ;; pos i+1 j-1 doit être vivante
                    local.get $i
                    i32.const 1
                    i32.add
                    local.get $j
                    i32.const 1
                    i32.sub
                    call $get_2d
                    i32.and

                    ;; pos i j-1 doit être vivante
                    local.get $i
                    local.get $j
                    i32.const 1
                    i32.sub
                    call $get_2d
                    i32.and

                    i32.or

                    ;; 4eme carré

                    ;; pos i j doit être vivante
                    local.get $i
                    local.get $j
                    call $get_2d

                     ;; pos i j-1 doit être vivante
                    local.get $i
                    local.get $j
                    i32.const 1
                    i32.sub
                    call $get_2d
                    i32.and

                    ;; pos i-1 j-1 doit être vivante
                    local.get $i
                    i32.const 1
                    i32.sub
                    local.get $j
                    i32.const 1
                    i32.sub
                    call $get_2d
                    i32.and

                    ;; pos i-1  j doit être vivante
                    local.get $i
                    i32.const 1
                    i32.sub
                    local.get $j
                    call $get_2d

                    i32.and

                    i32.or

                    (if (then unreachable))


                    (local.set $j (i32.add (local.get $j) (i32.const 1)))
                    (br $loop_j)
                    )
                )

                (local.set $i (i32.add (local.get $i) (i32.const 1)))
                (br $loop_i)
                )
            )
    )








      (func $choix_config (param $choix i32)

    
        local.get $choix
        i32.const 1
        i32.eq 

        (if 
            (then 
                call $contrainte_1

            )
        )

        local.get $choix
        i32.const 2
        i32.eq 

        (if 
            (then 
                call $contrainte_2

            )
        )

        local.get $choix
        i32.const 3
        i32.eq 

        (if 
            (then 
                call $contrainte_3

            )
        )

        local.get $choix
        i32.const 4
        i32.eq 

        (if 
            (then 
                call $contrainte_4

            )
        )
        local.get $choix
        i32.const 5
        i32.eq 

        (if 
            (then 
                call $contrainte_5

            )
        )
        local.get $choix
        i32.const 8
        i32.eq 

        (if 
            (then 
                call $contrainte_8

            )
        )
        local.get $choix
        i32.const 9
        i32.eq 

        (if 
            (then 
                call $contrainte_9

            )
        )
        local.get $choix
        i32.const 10
        i32.eq 

        (if 
            (then 
                call $contrainte_10

            )
        )
        local.get $choix
        i32.const 11
        i32.eq 

        (if 
            (then 
                call $contrainte_11

            )
        )
        local.get $choix
        i32.const 12
        i32.eq 

        (if 
            (then 
                call $contrainte_12

            )
        )
        local.get $choix
        i32.const 13
        i32.eq 

        (if 
            (then 
                call $contrainte_13

            )
        )



    )


    (func $main
        ;; nous devons faire ainsi pour avoir la largeur et la longueur dans le fichier de config json une fois en concrete
        (local $i i32)
        call $get_config_symb
        (local.set $i)

        call $init_dimension
        call $init_mem
        local.get $i
        call $choix_config
    )

    (start $main)
)



