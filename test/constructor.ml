open Core
open Olox_lib

let%expect_test "call_init_explicitly.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/constructor/call_init_explicitly.lox" in 
  Reader.interpret filepath;
  [%expect {| Foo.init(one)Runtime error : his Empty enviroment |}]
;;

let%expect_test "return_in_nested_function.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/constructor/return_in_nested_function.lox" in 
  Reader.interpret filepath;
  [%expect {| barInstance of Foo |}]
;;

let%expect_test "call_init_early_return.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/constructor/call_init_early_return.lox" in 
  Reader.interpret filepath;
  [%expect {| 5 print Expect ';' after return value |}]
;;

let%expect_test "default_arguments.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/constructor/default_arguments.lox" in 
  Reader.interpret filepath;
;;

let%expect_test "extra_arguments.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/constructor/extra_arguments.lox" in 
  Reader.interpret filepath;
  [%expect {| Number of arguments supplied less than number of parameters |}]
;;

let%expect_test "default.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/constructor/default.lox" in 
  Reader.interpret filepath;
  [%expect {| Instance of Foo |}]
;;

let%expect_test "init_not_method.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/constructor/init_not_method.lox" in 
  Reader.interpret filepath;
  [%expect {| not initializer |}]
;;

let%expect_test "return_value.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/constructor/return_value.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : return Can't return from an initializer |}]
;;

let%expect_test "arguments.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/constructor/arguments.lox" in 
  Reader.interpret filepath;
  [%expect {| initRuntime error : his Empty enviroment |}]
;;

let%expect_test "missing_arguments.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/constructor/missing_arguments.lox" in 
  Reader.interpret filepath;
  [%expect {| Number of arguments supplied less than number of parameters |}]
;;

let%expect_test "early_return.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/constructor/early_return.lox" in 
  Reader.interpret filepath;
  [%expect {| 5 print Expect ';' after return value |}]
;;
