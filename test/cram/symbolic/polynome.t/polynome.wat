(module
    (func $i32_symbol (import "ono" "i32_symbol") (result i32))
    (func $print_i32 (import "ono" "print_i32") (param i32))
    (func $polynomeA (import "ono" "polynomeA") (result i32))
    (func $polynomeB (import "ono" "polynomeB") (result i32))
    (func $polynomeC (import "ono" "polynomeC") (result i32))
    (func $polynomeD (import "ono" "polynomeD") (result i32))
    (func $debug (import "ono" "debug"))

    (func $solve_polynome
        (local $x i32)
        (local $a i32)
        (local $b i32)
        (local $c i32)
        (local $d i32)
        (local $poly i32)
        (local $tmp_x i32)
        (local $i i32)

        ;; Demande à l'utilisateur des coéf du polynome
        call $polynomeA
        local.set $a
        call $polynomeB
        local.set $b
        call $polynomeC
        local.set $c
        call $polynomeD
        local.set $d






        ;; Construction du polynome 
        call $i32_symbol
        local.set $x

        ;; poly = a*x 
        local.get $a
        local.get $x
        i32.mul

        ;; poly = a*x + b
        local.get $b
        i32.add

        ;; poly = (a*x + b)*x
        local.get $x
        i32.mul

        ;; poly = ((a*x + b)*x + c)
        local.get $c
        i32.add

        ;; poly = (((a*x + b)*x + c)*x)
        local.get $x
        i32.mul

        ;; poly = (((...)*x + d)
        local.get $d
        i32.add

        local.set $poly


        ;; if (poly == 0)
        local.get $poly
        i32.const 0 
        i32.eq ;; [poly == 0] avec un certain x


        ;; {poly == 0}
        (if 
            (then
            )
            (else return)
        ) 

        
        ;; Boucle qui va construire le polynome avec un nouveau x à chaque itération ajouter une nouvelle solution pour le solveur
        (block $stop
            (loop $loop

                ;; ;; Construction du polynome 
                ;; call $i32_symbol
                ;; local.set $x

                ;; forcer le solveur à trouver un nouveau x
                call $i32_symbol
                local.tee $tmp_x 
                local.get $x
                i32.gt_s ;; [tmp_x > x]
                (if
                    (then
                
                        ;; poly = a*x 
                        local.get $a
                        local.get $x
                        i32.mul

                        ;; poly = a*x + b
                        local.get $b
                        i32.add

                        ;; poly = (a*x + b)*x
                        local.get $x
                        i32.mul

                        ;; poly = ((a*x + b)*x + c)
                        local.get $c
                        i32.add

                        ;; poly = (((a*x + b)*x + c)*x)
                        local.get $x
                        i32.mul

                        ;; poly = (((...)*x + d)
                        local.get $d
                        i32.add

                        local.set $poly


                        ;; if (poly == 0)
                        local.get $poly
                        i32.const 0 
                        i32.eq ;; [poly == 0] avec un certain x
                        
                        ;; {poly == 0}
                        (if 
                            (then
                        
                                ;; nous pouvons mettre à jour le x pour repartir à 0
                                local.get $tmp_x
                                local.set $x


                                local.get $i 
                                i32.const 1 
                                i32.add 

                                local.tee $i

                                i32.const 3
                                i32.eq 
                                
                                (if (then br $stop))

                                br $loop
            
                            )
                            (else return)
                        ) 
                    )
                    (else return)
                )

            )
        )
    
        ;; si on arrive ici c'est que nous avons fini l'ensemble des solutions 
        unreachable

    )

    ;; un polynome de degré 3 admet au plus 3 solutions 
    (func $solve_polynome_bis
        (local $x i32)
        (local $a i32)
        (local $b i32)
        (local $c i32)
        (local $d i32)
        (local $poly i32)
        (local $tmp_x i32)
        (local $i i32)

        ;; Demande à l'utilisateur des coéf du polynome
        call $polynomeA
        local.set $a
        call $polynomeB
        local.set $b
        call $polynomeC
        local.set $c
        call $polynomeD
        local.set $d

        ;; Construction du polynome_1
        call $i32_symbol
        local.set $x

        ;; poly = a*x 
        local.get $a
        local.get $x
        i32.mul

        ;; poly = a*x + b
        local.get $b
        i32.add

        ;; poly = (a*x + b)*x
        local.get $x
        i32.mul

        ;; poly = ((a*x + b)*x + c)
        local.get $c
        i32.add

        ;; poly = (((a*x + b)*x + c)*x)
        local.get $x
        i32.mul

        ;; poly = (((...)*x + d)
        local.get $d
        i32.add

        local.set $poly


        ;; if (poly == 0)
        local.get $poly
        i32.const 0 
        i32.eq ;; [poly == 0] avec un certain x


        ;; {poly == 0}
        (if 
            (then
                ;; Construction du polynome_2
                call $i32_symbol
                local.tee $tmp_x
                local.get $x 
                i32.gt_s 

                (if 
                    (then
                        local.get $tmp_x
                        local.set $x 

                        ;; poly = a*x 
                        local.get $a
                        local.get $x
                        i32.mul
                        ;; poly = a*x + b
                        local.get $b
                        i32.add
                        ;; poly = (a*x + b)*x
                        local.get $x
                        i32.mul
                        ;; poly = ((a*x + b)*x + c)
                        local.get $c
                        i32.add
                        ;; poly = (((a*x + b)*x + c)*x)
                        local.get $x
                        i32.mul
                        ;; poly = (((...)*x + d)
                        local.get $d
                        i32.add

                        local.tee $poly
                        i32.const 0 
                        i32.eq

                        (if
                            (then 
                                ;; Construction du polynome_3 s'il existe 
                                call $i32_symbol
                                local.tee $tmp_x
                                local.get $x 
                                i32.gt_s 

                                (if 
                                    (then
                                        local.get $tmp_x
                                        local.set $x 

                                        ;; poly = a*x 
                                        local.get $a
                                        local.get $x
                                        i32.mul
                                        ;; poly = a*x + b
                                        local.get $b
                                        i32.add
                                        ;; poly = (a*x + b)*x
                                        local.get $x
                                        i32.mul
                                        ;; poly = ((a*x + b)*x + c)
                                        local.get $c
                                        i32.add
                                        ;; poly = (((a*x + b)*x + c)*x)
                                        local.get $x
                                        i32.mul
                                        ;; poly = (((...)*x + d)
                                        local.get $d
                                        i32.add

                                        local.tee $poly
                                        i32.const 0 
                                        i32.eq

                                        (if 
                                            (then unreachable)
                                            (else return)
                                        )
                                    )
                                )
                            )
                            (else return)
                        )
                    )
                )
            )
            (else return)
        ) 
    )

    (func $calculer_poly 
        (param $x i32) (param $a i32) (param $b i32) (param $c i32) (param $d i32)
        (result i32)

        ;; (a * x)
        local.get $a
        local.get $x
        i32.mul
        
        ;; + b
        local.get $b
        i32.add
        
        ;; * x
        local.get $x
        i32.mul
        
        ;; + c
        local.get $c
        i32.add
        
        ;; * x
        local.get $x
        i32.mul
        
        ;; + d
        local.get $d
        i32.add

    )   

    (func $solut_3
        (param $x1 i32) (param $x2 i32) (param $x3 i32)
        (param $a i32) (param $b i32) (param $c i32) (param $d i32)
        (result i32)

        ;; vérifie x1 est racine
        local.get $x1
        local.get $a local.get $b local.get $c local.get $d
        call $calculer_poly 
        i32.const 0
        i32.eq
        
        ;; vérifie si x2 est racine 
        local.get $x2
        local.get $a local.get $b local.get $c local.get $d
        call $calculer_poly
        i32.const 0
        i32.eq 

        ;; x1 != x2
        local.get $x1
        local.get $x2
        i32.ne

        i32.and
        i32.and 

        ;; vérifie si x3 est racine
        local.get $x3
        local.get $a local.get $b local.get $c local.get $d
        call $calculer_poly
        i32.const 0
        i32.eq

        ;; x1 != x3 
        local.get $x2
        local.get $x3
        i32.ne

        ;; x2 != x3
        local.get $x1
        local.get $x3
        i32.ne
        
        i32.and
        i32.and
        i32.and
    )

    (func $solut_2 
        (param $x1 i32) (param $x2 i32)
        (param $a i32) (param $b i32) (param $c i32) (param $d i32)
        (result i32)

        ;; vérifie si x1 est racine
        local.get $x1
        local.get $a local.get $b local.get $c local.get $d
        call $calculer_poly 
        i32.const 0
        i32.eq
        
        ;; vérifie si x2 est racine 
        local.get $x2
        local.get $a local.get $b local.get $c local.get $d
        call $calculer_poly
        i32.const 0
        i32.eq
        
        ;; x1 != x2
        local.get $x1
        local.get $x2
        i32.ne
        
        i32.and
        i32.and

    )

    (func $solut_1 
        (param $x i32) (param $a i32) (param $b i32) (param $c i32) (param $d i32) 
        (result i32)
        
        local.get $x

        local.get $a local.get $b local.get $c local.get $d
        call $calculer_poly 
        
        i32.const 0
        i32.eq
    )

    (func $solve_3_solutions
        (local $x1 i32) (local $x2 i32) (local $x3 i32)
        (local $a i32) (local $b i32) (local $c i32) (local $d i32)

        call $i32_symbol local.tee $x1
        call $i32_symbol local.tee $x2
        call $i32_symbol local.tee $x3

        call $polynomeA local.tee $a
        call $polynomeB local.tee $b
        call $polynomeC local.tee $c
        call $polynomeD local.tee $d

        call $solut_3

        (if 
            (then unreachable) 
            (else

                local.get $x1 local.get $x2
                local.get $a local.get $b local.get $c local.get $d
                call $solut_2 
                (if 
                    (then unreachable)
                    (else 

                        local.get $x1
                        local.get $a local.get $b local.get $c local.get $d
                        call $solut_1

                        (if
                            (then unreachable)
                            (else return)
                        )
                    )
                )
            )
        )
    )
    


     (func $solve_polynome_bis_2
        (local $x i32)
        (local $a i32)
        (local $b i32)
        (local $c i32)
        (local $d i32)
        (local $poly i32)
        (local $i i32)

        ;; Demande à l'utilisateur des coéf du polynome
        call $polynomeA
        local.set $a
        call $polynomeB
        local.set $b
        call $polynomeC
        local.set $c
        call $polynomeD
        local.set $d

        ;; Construction du polynome_1
        call $i32_symbol
        local.set $x

        ;; poly = a*x 
        local.get $a
        local.get $x
        i32.mul

        ;; poly = a*x + b
        local.get $b
        i32.add

        ;; poly = (a*x + b)*x
        local.get $x
        i32.mul

        ;; poly = ((a*x + b)*x + c)
        local.get $c
        i32.add

        ;; poly = (((a*x + b)*x + c)*x)
        local.get $x
        i32.mul

        ;; poly = (((...)*x + d)
        local.get $d
        i32.add

        local.set $poly


        ;; if (poly == 0)
        local.get $poly
        i32.const 0 
        i32.eq ;; [poly == 0] avec un certain x


        ;; {poly == 0}
        (if 
            (then
                unreachable
            ) 
            (else return)
        )
    )

    (start $solve_3_solutions)
)

