open Core
open Olox_lib

let%expect_test "add_num_nil" = 
"
1 + nil; // expect runtime error: Operands must be two numbers or two strings.
"
|> Interpreter.interpret;
;;
    