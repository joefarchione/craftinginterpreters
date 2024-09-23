open Core
open Olox_lib

let%expect_test "trees.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/benchmark/trees.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : return Can't return from top-level code |}]
;;

let%expect_test "zoo.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/benchmark/zoo.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : return Can't return from top-level code |}]
;;

let%expect_test "instantiation.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/benchmark/instantiation.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : clock Empty enviroment |}]
;;

let%expect_test "properties.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/benchmark/properties.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : return Can't return from top-level code |}]
;;

let%expect_test "binary_trees.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/benchmark/binary_trees.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : return Can't return from top-level code |}]
;;

let%expect_test "string_equality.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/benchmark/string_equality.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : clock Empty enviroment |}]
;;

let%expect_test "zoo_batch.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/benchmark/zoo_batch.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : return Can't return from top-level code |}]
;;

let%expect_test "equality.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/benchmark/equality.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : clock Empty enviroment |}]
;;

let%expect_test "method_call.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/benchmark/method_call.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : return Can't return from top-level code |}]
;;

let%expect_test "invocation.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/benchmark/invocation.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : clock Empty enviroment |}]
;;

let%expect_test "fib.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/benchmark/fib.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : clock Empty enviroment |}]
;;
