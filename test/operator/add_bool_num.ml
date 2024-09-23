open Core
open Olox_lib

let%expect_test "add_bool_num" = 
"
true + 123; // expect runtime error: Operands must be two numbers or two strings.
"
|> Interpreter.interpret;
;;
    