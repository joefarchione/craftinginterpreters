open Core
open Olox_lib

let%expect_test "evaluate.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/expressions/evaluate.lox" in 
  Reader.interpret filepath;
  [%expect {| 2 |}]
;;

let%expect_test "parse.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/expressions/parse.lox" in 
  Reader.interpret filepath;
  [%expect {| 2 |}]
;;
