open Core
open Olox_lib

let%expect_test "nested_call_with_arguments" = 
"
fun returnArg(arg) {
  return arg;
}

fun returnFunCallWithArg(func, arg) {
  return returnArg(func)(arg);
}

fun printArg(arg) {
  print arg;
}

returnFunCallWithArg(printArg, \"hello world\"); // expect: hello world
"
|> Interpreter.interpret;
;;
    