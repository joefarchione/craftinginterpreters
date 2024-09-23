open Core
open Olox_lib

let%expect_test "literal.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/nil/literal.lox" in 
  Reader.interpret filepath;
  [%expect {| Nil |}]
;;
