open Core
open Olox_lib

let%expect_test "add_bool_nil" = 
"
true + nil; // expect runtime error: Operands must be two numbers or two strings.
"
|> Interpreter.interpret;
;;
    