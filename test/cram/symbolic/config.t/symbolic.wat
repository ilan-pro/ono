(module
    (func $i32_symbol (import "ono" "i32_symbol") (result i32))
    (func $print_i32 (import "ono" "print_i32") (param i32))
    
    (global $largeur (mut i32) (i32.const 3))
    (global $longueur (mut i32) (i32.const 3))
    (memory 10)

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
                (local.set $tmp_x (call $i32_symbol))
                ;;On limite au valeurs (0,1)
                (if (i32.or
                        (i32.lt_s (local.get $tmp_x) (i32.const 0))
                        (i32.gt_s (local.get $tmp_x) (i32.const 1)))
                    (then
                        return
                    )
                )
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



    ;; Implémente les règles du Game of Life avec double buffer
    ;; - Phase 1 : Calcule le nouvel état dans buffer temporaire
    ;; - Phase 2 : Recopie le buffer temporaire vers grille principale
    (func $step 
        (local $i i32)   
        (local $j i32)    
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

    (func $all
        (local $nb_alive i32)


        call $step
        call $count_alive
        (local.set $nb_alive)
        
        (i32.eq (local.get $nb_alive) (i32.const 3))
        (if 
            (then unreachable)
        )
    )

    (func $main
        call $init_mem
        call $all
    )

    (start $main)
)
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