open Core
open Olox_lib

let%expect_test "empty_file.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/unexpected_character.lox" in 
  Reader.interpret filepath;
  [%expect {| 3 | Invalid char |}]
;;



