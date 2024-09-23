open Core
open Olox_lib

let%expect_test "missing_argument.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/print/missing_argument.lox" in 
  Reader.interpret filepath;
  [%expect {| 2 ; Incorrect tag for primary expression |}]
;;
