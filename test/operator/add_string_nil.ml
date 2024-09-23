open Core
open Olox_lib

let%expect_test "add_string_nil" = 
"
\"s\" + nil; // expect runtime error: Operands must be two numbers or two strings.
"
|> Interpreter.interpret;
;;
    