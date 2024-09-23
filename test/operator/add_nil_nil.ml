open Core
open Olox_lib

let%expect_test "add_nil_nil" = 
"
nil + nil; // expect runtime error: Operands must be two numbers or two strings.
"
|> Interpreter.interpret;
;;
    