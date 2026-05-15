Check that branching works:
  $ ono symbolic branching_false.wat -vv
  ono: [INFO] Parsing file branching_false.wat...
  ono: [DEBUG] Parsed module is:  
               (module
                 (import "ono" "i32_symbol" (func $i32_symbol  (result i32)))
                 (import "ono" "print_i32" (func $print_i32  (param i32)))
                 (func $main (local $n i32) (local $n2 i32) (local $n3 i32)
                   call $i32_symbol
                   local.tee $n
                   i32.const 42
                   i32.ne
                   call $i32_symbol
                   local.tee $n2
                   i32.const 42
                   i32.ne
                   i32.or
                   local.get $n
                   local.get $n2
                   i32.lt_u
                   i32.or
                   call $i32_symbol
                   local.tee $n3
                   i32.const 42
                   i32.ne
                   i32.or
                   local.get $n2
                   local.get $n3
                   i32.lt_u
                   i32.or
                   unreachable
                 )
                 (start $main)
               )
  ono: [INFO] Compiling to Wasm...
  ono: [DEBUG] Compiled module is:  
               (module
                 (import "ono" "i32_symbol" (func $i32_symbol  (result i32)))
                 (import "ono" "print_i32" (func $print_i32  (param i32)))
                 (type (func (result i32)))
                 (type (func (param i32)))
                 (type (func))
                 (func $main (local $n i32) (local $n2 i32) (local $n3 i32)
                   call 0
                   local.tee 0
                   i32.const 42
                   i32.ne
                   call 0
                   local.tee 1
                   i32.const 42
                   i32.ne
                   i32.or
                   local.get 0
                   local.get 1
                   i32.lt_u
                   i32.or
                   call 0
                   local.tee 2
                   i32.const 42
                   i32.ne
                   i32.or
                   local.get 1
                   local.get 2
                   i32.lt_u
                   i32.or
                   unreachable
                 )
                 (start 2)
               )
  ono: [INFO] Validating...
  ono: [INFO] Linking...
  ono: [INFO] Interpreting...
  ono: [ERROR] Trap: unreachable
  ono: [DEBUG] scope tokens: [symbol symbol_0 ; symbol symbol_1 ; symbol symbol_2]
  ono: [ERROR] owi error: create temporary file config/bos-78cd21.tmp: No such file or directory
  [123]
  $ ono symbolic branching_true.wat -vv
  ono: [INFO] Parsing file branching_true.wat...
  ono: [DEBUG] Parsed module is:  
               (module
                 (import "ono" "i32_symbol" (func $i32_symbol  (result i32)))
                 (import "ono" "print_i32" (func $print_i32  (param i32)))
                 (func $main (local $n i32)
                   call $i32_symbol
                   local.tee $n
                   i32.const 42
                   i32.lt_s
                   (if
                     (then
                       unreachable
                     )
                     (else
                       return
                     )
                   )
                 )
                 (start $main)
               )
  ono: [INFO] Compiling to Wasm...
  ono: [DEBUG] Compiled module is:  
               (module
                 (import "ono" "i32_symbol" (func $i32_symbol  (result i32)))
                 (import "ono" "print_i32" (func $print_i32  (param i32)))
                 (type (func (result i32)))
                 (type (func (param i32)))
                 (type (func))
                 (func $main (local $n i32)
                   call 0
                   local.tee 0
                   i32.const 42
                   i32.lt_s
                   (if
                     (then
                       unreachable
                     )
                     (else
                       return
                     )
                   )
                 )
                 (start 2)
               )
  ono: [INFO] Validating...
  ono: [INFO] Linking...
  ono: [INFO] Interpreting...
  ono: [ERROR] Trap: unreachable
  ono: [DEBUG] scope tokens: [symbol symbol_0]
  ono: [ERROR] owi error: create temporary file config/bos-40d966.tmp: No such file or directory
  [123]
