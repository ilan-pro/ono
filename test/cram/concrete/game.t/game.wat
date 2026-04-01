(module

    (func $clear_screen (import "ono" "clear_screen"))
    (func $newline (import "ono" "newline"))
    (func $cell_print (import "ono" "cell_print") (param i32))
    (func $handle_camera_input (import "ono" "handle_camera_input") (param i32) (param i32))
    (func $print_i32 (import "ono" "print_i32") (param i32))
    (func $print_i32_custom (import "ono" "print_i32_custom") (param i32) (param i32))
    (func $random_i32 (import "ono" "random_i32") (param i32) (result i32))
    (func $debogue_index (import "ono" "debogue_index") (param i32))
    (func $debogue_valeur (import "ono" "debogue_valeur") (param i32))
    (func $print_separateur (import "ono" "print_separateur") (param i32))
    (func $get_steps (import "ono" "get_steps") (result i32))
    (func $get_last (import "ono" "get_last") (result i32))
    (func $config_not_null (import "ono" "config_not_null") (result i32))
    (func $get_width (import "ono" "get_width") (result i32))
    (func $get_length (import "ono" "get_length") (result i32))
    (func $get_alive (import "ono" "get_alive") (param i32) (param i32) (result i32))
    (func $read_int (import "ono" "read_int") (result i32))
    
    (func $open_window (import "ono" "open_window"))
    (func $close_window (import "ono" "close_window"))
    (func $is_close (import "ono" "is_close") (result i32))
    (func $end_drawing (import "ono" "end_drawing"))
    (func $begin_drawing (import "ono" "begin_drawing"))
    (func $cell_print_inter (import "ono" "cell_print_inter") (param i32) (param i32) (param i32))
    (func $clear_background (import "ono" "clear_background"))
    (func $sleep (import "ono" "sleep") (param i32))
    (func $sleepf (import "ono" "sleepf") (param i32))

    (global $largeur (mut i32) (i32.const 4))
    (global $longueur (mut i32) (i32.const 4))
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
                i32.const 50 ;; 50% de chance d'avoir une cellule vivante
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

    (func $init_with_config
        (local $size i32) 
        (local $ptr i32)
        (local $rand i32)
        (local $i i32) ;; obligé pour avoir la vraie position dans le décalage car on travaille avec 
        ;; des cases mémoire sur 32 bits soit 4 octets et donc ptr pointe sur l'adresse d'une case
        ;; qui n'est pas forcémenet 0,1,2...

        call $get_width
        call $get_length

        global.set $longueur 
        global.set $largeur 
        

        (i32.mul (global.get $longueur) (global.get $largeur))

        (local.set $size)
        (local.set $ptr (i32.const 0))
        (local.set $i (i32.const 0))

        (block $remplissage ;; on la remplit (TODO mette les valeurs aléatoire via random_I32)
            (loop $loop
                ;; if n == 0 then void
                (i32.eq (local.get $size) (i32.const 0))
                br_if $remplissage

                ;; n-1
                (i32.sub (local.get $size) (i32.const 1))
                local.set $size
                
                (call $get_alive (call $get_pos_2d (local.get $i)))

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

                ;; ptr++ (donc ajouter 4 octets à chaque fois)
                (i32.add (local.get $ptr) (i32.const 4))
                local.set $ptr

                ;; i++
                (local.set $i (i32.add (local.get $i) (i32.const 1))) 

                br $loop
            )
        )
    )

    ;; fonction pour transformer position en cordonnée matriciel
    (func $get_pos_2d (param $pos i32) (result i32 i32)
        (local $i i32)
        (local $j i32)

        ;; division entière non signée 
        (local.set $i (i32.div_u (local.get $pos) (global.get $largeur)))
        ;; rem c'est le reste de la division non signée soit le modulo 
        (local.set $j (i32.rem_u (local.get $pos) (global.get $largeur)))

        (local.get $i)
        (local.get $j)

        ;; (local.get $i)
        ;; (local.get $j)
        ;; (call $print_i32_custom)
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
        local.get $j
        local.get $i
        global.get $largeur
        i32.mul
        i32.add
        i32.const 4
        i32.mul
        local.get $v
        i32.store
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

    (func $print_grid 
        (local $i i32) 
        (local $j i32)

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

                ;; local.get $i
                ;; local.get $j
                ;; call $get_2d
                ;; call $debogue_valeur
                ;; local.get $i
                ;; call $debogue_index
                ;; local.get $j
                ;; call $debogue_index
                


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
        (call $clear_screen)
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

    ;; FONCTION STEP - Coeur du Game of Life
    ;; Implémente les règles du Game of Life avec double buffer
    ;; - Phase 1 : Calcule le nouvel état dans buffer temporaire
    ;; - Phase 2 : Recopie le buffer temporaire vers grille principale
    (func $step 
        (local $i i32)    ;; Indice de ligne (0-19)
        (local $j i32)    ;; Indice de colonne (0-19)
        (local $n i32)    ;; Nombre de voisins vivants
        (local $v i32)    ;; Nouvel état de la cellule

        ;; PHASE 1 : PARCOURS ET CALCUL DANS BUFFER TEMPO
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

                        ;; debogue
                        ;; local.get $i 
                        ;; call $debogue_index
                        ;; local.get $j 
                        ;; call $debogue_index
                        ;; local.get $n
                        ;; call $debogue_valeur


                        ;; Récupérer l'état actuel de la cellule
                        local.get $i
                        local.get $j
                        call $get_2d
                        local.set $v

                        ;; APPLIQUER LES RÈGLES DU GAME OF LIFE
                        local.get $v
                        i32.const 1
                        i32.eq
                        (if (result i32)
                            ;; CELLULE VIVANTE : Survit avec 2 ou 3 voisins
                            (then
                                local.get $n
                                i32.const 2
                                i32.eq
                                local.get $n
                                i32.const 3
                                i32.eq
                                i32.or
                            )
                            ;; CELLULE MORTE : Naît avec exactement 3 voisins
                            (else
                                local.get $n
                                i32.const 3
                                i32.eq
                            )
                        )
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
        ;; PHASE 2 : RECOPIE BUFFER TEMPO VERS GRILLE PRINCIPALE
        call $copy_tmp
    )

    (func $print_grid_inter 
        (local $i i32) 
        (local $j i32)

        global.get $largeur
        global.get $longueur
        call $handle_camera_input

        (call $begin_drawing)
        (call $clear_background)

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

                (call $cell_print_inter
                    (call $get_2d
                    (local.get $i)
                    (local.get $j)
                    )
                    (local.get $i)
                    (local.get $j)
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
        (call $end_drawing)
    )


   (func $main
        (local $i i32)
        (local $borne i32)
        (local $iterlast i32)
        (local $time i32)
        (local $frame i32)


        i32.const 9
        local.set $time

        call $read_int
        global.set $largeur

        call $read_int
        global.set $longueur

        (call $config_not_null)
        (call $open_window)

        (if 
            (then call $init_with_config) 
            (else call $init)  
        )

        i32.const 0
        local.set $i

        (call $get_steps)
        (local.set $borne)
        (local.get $borne)
        (call $get_last)
        (i32.sub)
        (local.set $iterlast)

        (block $stop
            (loop $loop
                ;; (i32.eq (local.get $i) (i32.const 5))
                (i32.eq (local.get $i)  (local.get $borne))
                br_if $stop 
                ;; ordre pour bien voir tous les affichages
                local.get $i 
                (i32.ge_s (local.get $i)  (local.get $iterlast))
                   (if (then
                        ;; (local.get $i)  
                        ;; (call $print_separateur)
                        ;; (call $print_grid)
                        
                        (call $is_close)
                        (if (then
                            (call $print_grid_inter)                           
                            )
                        )
                        )
                    )

                local.get $time
                call $sleepf
                               
                call $step

            ;; local.get $frame
            ;; i32.const 1
            ;; i32.add
            ;; local.set $frame

            ;; local.get $frame
            ;; i32.const 50
            ;; i32.ge_u
            ;; (if
            ;; (then
            ;;     call $step

                
                local.get $i
                i32.const 1
                i32.add
                local.set $i

                
            ;;     i32.const 0
            ;;     local.set $frame
            ;; )
            ;; )

                br $loop
            )
        )
    )

    (start $main)
)

    