open Core
open Olox_lib

let%expect_test "punctuators.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/scanning/punctuators.lox" in 
  Reader.interpret filepath;
  [%expect {| 1 ) Incorrect tag for primary expression |}]
;;

let%expect_test "identifiers.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/scanning/identifiers.lox" in 
  Reader.interpret filepath;
  [%expect {| 1 _ Invalid char |}]
;;

let%expect_test "keywords.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/scanning/keywords.lox" in 
  Reader.interpret filepath;
  [%expect {| 1 and Incorrect tag for primary expression |}]
;;

let%expect_test "strings.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/scanning/strings.lox" in 
  Reader.interpret filepath;
  [%expect {| 2 "string" Expect ';' after value |}]
;;

let%expect_test "numbers.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/scanning/numbers.lox" in 
  Reader.interpret filepath;
  [%expect {| 2 123.456 Expect ';' after value |}]
;;

let%expect_test "whitespace.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/scanning/whitespace.lox" in 
  Reader.interpret filepath;
  [%expect {| 1 	 Invalid char |}]
;;
