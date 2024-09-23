open Core
open Olox_lib

let%expect_test "multiline.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/string/multiline.lox" in 
  Reader.interpret filepath;
  [%expect {|
    1
    2
    3
    |}]
;;

let%expect_test "unterminated.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/string/unterminated.lox" in 
  Reader.interpret filepath;
  [%expect {| 2 EOF Unterminated string |}]
;;

let%expect_test "error_after_multiline.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/string/error_after_multiline.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : err Empty enviroment |}]
;;

let%expect_test "literals.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/string/literals.lox" in 
  Reader.interpret filepath;
  [%expect {| ()a stringA~¶Þॐஃ |}]
;;
