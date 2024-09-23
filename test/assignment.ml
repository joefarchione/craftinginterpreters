open Core
open Olox_lib

let%expect_test "global.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/assignment/global.lox" in 
  Reader.interpret filepath;
  [%expect {| beforeafterargarg |}]
;;

let%expect_test "syntax.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/assignment/syntax.lox" in 
  Reader.interpret filepath;
  [%expect {| varvar |}]
;;

let%expect_test "associativity.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/assignment/associativity.lox" in 
  Reader.interpret filepath;
  [%expect {| ccc |}]
;;

let%expect_test "local.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/assignment/local.lox" in 
  Reader.interpret filepath;
  [%expect {| beforeafterargarg |}]
;;

let%expect_test "undefined.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/assignment/undefined.lox" in 
  Reader.interpret filepath;
;;

let%expect_test "grouping.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/assignment/grouping.lox" in 
  Reader.interpret filepath;
  [%expect {| 2 =  Expect ';' after value |}]

;;

let%expect_test "infix_operator.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/assignment/infix_operator.lox" in 
  Reader.interpret filepath;
  [%expect {| 3 =  Expect ';' after value |}]
;;

let%expect_test "to_this.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/assignment/to_this.lox" in 
  Reader.interpret filepath;
;;

let%expect_test "prefix_operator.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/assignment/prefix_operator.lox" in 
  Reader.interpret filepath;
  [%expect {| 2 =  Incorrect tag for primary expression |}]
;;
