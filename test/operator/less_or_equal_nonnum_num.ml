open Core
open Olox_lib

let%expect_test "less_or_equal_nonnum_num" = 
"
\"1\" <= 1; // expect runtime error: Operands must be numbers.
"
|> Interpreter.interpret;
;;
    