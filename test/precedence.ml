open Core
open Olox_lib

let%expect_test "precedence.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/precedence.lox" in 
  Reader.interpret filepath;
  [%expect {| 14840falsefalsefalsefalse00004 |}]
;;

