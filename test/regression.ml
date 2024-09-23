open Core
open Olox_lib

let%expect_test "394.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/regression/394.lox" in 
  Reader.interpret filepath;
  [%expect {| B |}]
;;

let%expect_test "40.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/regression/40.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : capturedVar Undefined variable |}]
;;
