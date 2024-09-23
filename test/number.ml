open Core
open Olox_lib

let%expect_test "nan_equality.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/number/nan_equality.lox" in 
  Reader.interpret filepath;
  [%expect {| falsetruefalsetrue |}]
;;

let%expect_test "leading_dot.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/number/leading_dot.lox" in 
  Reader.interpret filepath;
  [%expect {| 2 . Incorrect tag for primary expression |}]
;;

let%expect_test "literals.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/number/literals.lox" in 
  Reader.interpret filepath;
  [%expect {| 1239876540-0123.456-0.001 |}]
;;

let%expect_test "decimal_point_at_eof.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/number/decimal_point_at_eof.lox" in 
  Reader.interpret filepath;
  [%expect {| -1 EOF Expect ';' after value |}]
;;

let%expect_test "trailing_dot.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/number/trailing_dot.lox" in 
  Reader.interpret filepath;
;;
