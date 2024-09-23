open Core
open Olox_lib

let%expect_test "missing_arguments" = 
"
fun f(a, b) {}

f(1); // expect runtime error: Expected 2 arguments but got 1.
"
|> Interpreter.interpret;
;;
    