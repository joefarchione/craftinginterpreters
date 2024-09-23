open Core
open Olox_lib

let%expect_test "only_line_comment_and_line.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/comments/only_line_comment_and_line.lox" in 
  Reader.interpret filepath;
;;

let%expect_test "unicode.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/comments/unicode.lox" in 
  Reader.interpret filepath;
  [%expect {| ok |}]
;;

let%expect_test "line_at_eof.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/comments/line_at_eof.lox" in 
  Reader.interpret filepath;
  [%expect {| ok |}]
;;

let%expect_test "only_line_comment.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/comments/only_line_comment.lox" in 
  Reader.interpret filepath;
;;
