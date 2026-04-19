(module
  (func $i32_symbol (import "ono" "i32_symbol") (result i32))
  (func $print_i32 (import "ono" "print_i32") (param i32))
  (func $polynome (import "ono" "polynome") (param i32) (result i32))
  (func $main
    (local $a i32)
    (local $b i32)
    (local $c i32)
    (local $d i32)
    (local $x i32)
    (local $x2 i32)
    (local $x3 i32)
    (local $poly i32)


    call $i32_symbol
    local.tee $x 
    local.get $x 
    i32.mul ;; nous avons x^2
    local.tee $x2 
    local.get $x 
    i32.mul ;; nous avons x^3 
    local.set $x3

    (call $polynome (i32.const 0))
    local.set $a ;; [a]
    
    ;; call $polynome (i32.const 1)
    ;; local.tee $b ;; [b;a]
    
    ;; call $polynome (i32.const 2)
    ;; local.tee $c ;; [c;b;a]
    
    ;; call $polynome (i32.const 3)
    ;; local.tee $d ;; [d;c;b;a]
    
    ;; local.get $poly ;; par défaut poly=0 | [poly=0;d;c;b;a]
    ;; i32.add ;; [d+0;c;b;a]
    ;; local.set $poly ;; [c;b;a] | poly = d 

    ;; ;; c * x
    ;; local.get $x 
    ;; i32.mul ;; [x * c;b;a]
    ;; local.set $poly ;; [b;a] | poly = d + x*c

    ;; ;; b * x^2 
    ;; local.get $b 
    ;; i32.mul ;; [x^2 * b; a]
    ;; local.set $poly  ;; [a] | poly = d + x*c + x^2*b

    ;; ;; a * x^3
    ;; local.get $a 
    ;; i32.mul ;; [x*3 * a]
    ;; local.tee $poly ;; [poly] | poly = d + x*c + x^2*b + x^3*a

    ;; ;; nous avons poly sur la pile maintenant mis à jour

    ;; ;; if (poly == 0)
    ;; i32.const 0 
    ;; i32.eq ;; [poly == 0]

    ;; (if 
    ;;     (then 
    ;;         unreachable
    ;;     )
    ;;     (else 
    ;;         return
    ;;     )
    ;; )
  )

  (start $main)
)

