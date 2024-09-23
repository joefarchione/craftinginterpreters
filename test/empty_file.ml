open Core
open Olox_lib

let%expect_test "empty_file.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/empty_file.lox" in 
  Reader.interpret filepath;
;;


