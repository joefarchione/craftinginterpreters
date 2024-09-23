open Core
open Olox_lib

let%expect_test "close_over_later_variable.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/closure/close_over_later_variable.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : b Undefined variable |}]
;;

let%expect_test "shadow_closure_with_local.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/closure/shadow_closure_with_local.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : foo Undefined variable |}]
;;

let%expect_test "reference_closure_multiple_times.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/closure/reference_closure_multiple_times.lox" in 
  Reader.interpret filepath;
  [%expect {| 5 _ Invalid char |}]
;;

let%expect_test "unused_later_closure.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/closure/unused_later_closure.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : returnA Undefined variable |}]
;;

let%expect_test "close_over_method_parameter.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/closure/close_over_method_parameter.lox" in 
  Reader.interpret filepath;
  [%expect {| 5 _ Invalid char |}]
;;

let%expect_test "reuse_closure_slot.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/closure/reuse_closure_slot.lox" in 
  Reader.interpret filepath;
  [%expect {| 6 _ Invalid char |}]
;;

let%expect_test "open_closure_in_function.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/closure/open_closure_in_function.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : local Undefined variable |}]
;;

let%expect_test "nested_closure.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/closure/nested_closure.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : 3 Undefined environment |}]
;;

let%expect_test "assign_to_closure.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/closure/assign_to_closure.lox" in 
  Reader.interpret filepath;
  [%expect {| 6 _ Invalid char |}]
;;

let%expect_test "close_over_function_parameter.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/closure/close_over_function_parameter.lox" in 
  Reader.interpret filepath;
  [%expect {| 4 _ Invalid char |}]
;;

let%expect_test "unused_closure.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/closure/unused_closure.lox" in 
  Reader.interpret filepath;
  [%expect {| ok |}]
;;

let%expect_test "assign_to_shadowed_later.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/closure/assign_to_shadowed_later.lox" in 
  Reader.interpret filepath;
  [%expect {| innerglobal |}]
;;

let%expect_test "closed_closure_in_function.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/closure/closed_closure_in_function.lox" in 
  Reader.interpret filepath;
  [%expect {| 5 _ Invalid char |}]
;;
