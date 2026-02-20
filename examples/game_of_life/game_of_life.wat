(module
  (import "ono" "random_i32" (func $random_i32 (param i32) (result i32)))
  (import "ono" "print_cell" (func $print_cell (param i32)))
  (import "ono" "newline" (func $newline))
  (import "ono" "clear_screen" (func $clear_screen))

  (memory (export "memory") 1)

  (global $w (mut i32) (i32.const 90))
  (global $h (mut i32) (i32.const 50))
  (global $grid_base i32 (i32.const 0))
  (global $neigh_base (mut i32) (i32.const 0))

  (func $grid_size (result i32)
    global.get $w
    global.get $h
    i32.mul)

  (func $init_bases
    call $grid_size
    global.set $neigh_base)

  (func $idx (param $i i32) (param $j i32) (result i32)
    local.get $i
    global.get $w
    i32.mul
    local.get $j
    i32.add)

  (func $in_bounds (param $i i32) (param $j i32) (result i32)
    local.get $i
    i32.const 0
    i32.lt_s
    if (result i32)
      i32.const 0
    else
      local.get $i
      global.get $h
      i32.ge_s
      if (result i32)
        i32.const 0
      else
        local.get $j
        i32.const 0
        i32.lt_s
        if (result i32)
          i32.const 0
        else
          local.get $j
          global.get $w
          i32.ge_s
          if (result i32)
            i32.const 0
          else
            i32.const 1
          end
        end
      end
    end)

  (func $is_alive (param $i i32) (param $j i32) (result i32)
    local.get $i
    local.get $j
    call $in_bounds
    i32.eqz
    if (result i32)
      i32.const 0
    else
      global.get $grid_base
      local.get $i
      local.get $j
      call $idx
      i32.add
      i32.load8_u
      i32.const 0
      i32.ne
    end)

  (func $count_alive_neighbours (param $i i32) (param $j i32) (result i32)
    (local $c i32)
    i32.const 0
    local.set $c

    local.get $c
    local.get $i
    i32.const 1
    i32.sub
    local.get $j
    i32.const 1
    i32.sub
    call $is_alive
    i32.add
    local.set $c

    local.get $c
    local.get $i
    i32.const 1
    i32.sub
    local.get $j
    call $is_alive
    i32.add
    local.set $c

    local.get $c
    local.get $i
    i32.const 1
    i32.sub
    local.get $j
    i32.const 1
    i32.add
    call $is_alive
    i32.add
    local.set $c

    local.get $c
    local.get $i
    local.get $j
    i32.const 1
    i32.sub
    call $is_alive
    i32.add
    local.set $c

    local.get $c
    local.get $i
    local.get $j
    i32.const 1
    i32.add
    call $is_alive
    i32.add
    local.set $c

    local.get $c
    local.get $i
    i32.const 1
    i32.add
    local.get $j
    i32.const 1
    i32.sub
    call $is_alive
    i32.add
    local.set $c

    local.get $c
    local.get $i
    i32.const 1
    i32.add
    local.get $j
    call $is_alive
    i32.add
    local.set $c

    local.get $c
    local.get $i
    i32.const 1
    i32.add
    local.get $j
    i32.const 1
    i32.add
    call $is_alive
    i32.add
    local.set $c

    local.get $c)

  (func $step (export "step")
    (local $i i32)
    (local $j i32)
    (local $count i32)
    (local $cell_alive i32)
    (local $live i32)
    (local $r i32)

    i32.const 0
    local.set $i
    loop $loop_i_neigh
      i32.const 0
      local.set $j
      loop $loop_j_neigh
        local.get $i
        local.get $j
        call $count_alive_neighbours
        local.set $count

        global.get $neigh_base
        local.get $i
        local.get $j
        call $idx
        i32.add
        local.get $count
        i32.store8

        local.get $j
        i32.const 1
        i32.add
        local.tee $j
        global.get $w
        i32.lt_s
        br_if $loop_j_neigh
      end

      local.get $i
      i32.const 1
      i32.add
      local.tee $i
      global.get $h
      i32.lt_s
      br_if $loop_i_neigh
    end

    i32.const 0
    local.set $i
    loop $loop_i_upd
      i32.const 0
      local.set $j
      loop $loop_j_upd
        local.get $i
        local.get $j
        call $is_alive
        local.set $cell_alive

        global.get $neigh_base
        local.get $i
        local.get $j
        call $idx
        i32.add
        i32.load8_u
        local.set $count

        local.get $cell_alive
        if (result i32)
          local.get $count
          i32.const 2
          i32.eq
          local.get $count
          i32.const 3
          i32.eq
          i32.or
        else
          local.get $count
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

        global.get $grid_base
        local.get $i
        local.get $j
        call $idx
        i32.add
        local.get $live
        i32.store8

        local.get $j
        i32.const 1
        i32.add
        local.tee $j
        global.get $w
        i32.lt_s
        br_if $loop_j_upd
      end

      local.get $i
      i32.const 1
      i32.add
      local.tee $i
      global.get $h
      i32.lt_s
      br_if $loop_i_upd
    end)

  (func $print_grid (export "print_grid")
    (local $i i32)
    (local $j i32)

    i32.const 0
    local.set $i
    loop $loop_i_print
      i32.const 0
      local.set $j
      loop $loop_j_print
        local.get $i
        local.get $j
        call $is_alive
        call $print_cell

        local.get $j
        i32.const 1
        i32.add
        local.tee $j
        global.get $w
        i32.lt_s
        br_if $loop_j_print
      end

      call $newline

      local.get $i
      i32.const 1
      i32.add
      local.tee $i
      global.get $h
      i32.lt_s
      br_if $loop_i_print
    end

    call $newline
    call $clear_screen)

  (func $init_grid (export "init_grid")
    (local $i i32)
    (local $j i32)
    (local $r i32)

    call $init_bases

    i32.const 0
    local.set $i
    loop $loop_i_init
      i32.const 0
      local.set $j
      loop $loop_j_init
        i32.const 100
        call $random_i32
        local.set $r

        global.get $grid_base
        local.get $i
        local.get $j
        call $idx
        i32.add
        local.get $r
        i32.const 90
        i32.gt_s
        i32.store8

        local.get $j
        i32.const 1
        i32.add
        local.tee $j
        global.get $w
        i32.lt_s
        br_if $loop_j_init
      end

      local.get $i
      i32.const 1
      i32.add
      local.tee $i
      global.get $h
      i32.lt_s
      br_if $loop_i_init
    end)

  (func $main (export "_start")
    call $init_grid
    call $print_grid
    call $step
    call $print_grid)
)
