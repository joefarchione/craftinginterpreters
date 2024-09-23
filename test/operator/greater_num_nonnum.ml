open Core
open Olox_lib

let%expect_test "greater_num_nonnum" = 
"
1 > \"1\"; // expect runtime error: Operands must be numbers.
"
|> Interpreter.interpret;
;;
    