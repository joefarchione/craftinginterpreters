open Core
open Olox_lib

let%expect_test "no_reuse_constants.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/limit/no_reuse_constants.lox" in 
  Reader.interpret filepath;
;;

let%expect_test "too_many_upvalues.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/limit/too_many_upvalues.lox" in 
  Reader.interpret filepath;
;;

let%expect_test "too_many_constants.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/limit/too_many_constants.lox" in 
  Reader.interpret filepath;
;;

let%expect_test "stack_overflow.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/limit/stack_overflow.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : foo Undefined variable |}]
;;

let%expect_test "too_many_locals.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/limit/too_many_locals.lox" in 
  Reader.interpret filepath;
;;

let%expect_test "loop_too_large.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/limit/loop_too_large.lox" in 
  Reader.interpret filepath;
;;
