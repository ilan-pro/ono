  $ ono concrete game.wat 
  Entrez une largeur : ono: internal error, uncaught exception:
       End_of_file
       Raised at Stdlib__Scanf.scanf_bad_input in file "scanf.ml", line 1126, characters 9-16
       Called from Ono__Concrete_ono_module.read_int in file "src/lib/concrete_ono_module.ml", line 106, characters 10-40
       Called from Owi__Interpret.Make.exec_extern_func.apply in file "vendor/owi/src/interpret/interpret.ml", line 610, characters 25-30
       Called from Owi__Interpret.Make.exec_extern_func in file "vendor/owi/src/interpret/interpret.ml", line 619, characters 13-45
       Called from Owi__Interpret.Make.exec_vfunc in file "vendor/owi/src/interpret/interpret.ml", line 838, characters 19-59
       Called from Owi__Interpret.Make.loop in file "vendor/owi/src/interpret/interpret.ml", line 1647, characters 19-53
       Called from Owi__Interpret.Make.modul.(fun) in file "vendor/owi/src/interpret/interpret.ml", lines 1723-1724, characters 14-39
       Called from Stdlib__List.fold_left in file "list.ml", line 125, characters 24-34
       Called from Owi__Interpret.Make.modul in file "vendor/owi/src/interpret/interpret.ml", lines 1716-1728, characters 6-9
       Called from Dune__exe__Cmd_concrete.term in file "src/tool/cmd_concrete.ml", line 64, characters 2-57
       Called from Cmdliner_term.app.(fun) in file "cmdliner_term.ml", line 22, characters 19-24
       Called from Cmdliner_eval.run_parser in file "cmdliner_eval.ml", line 41, characters 7-16
  ono: [ERROR] unhandled exception
  [125]
