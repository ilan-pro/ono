#!/usr/bin/env ocaml

#use "topfind";;
#require "owi";;
#require "ono";;

open Ono.Syntax

(* Test simple *)
let () =
  let* () = Ono.Concrete_driver.run ~source_file:(Fpath.v "../examples/factorial/factorial.wat") ~seed:None in
  print_endline "Factorial test completed successfully"
