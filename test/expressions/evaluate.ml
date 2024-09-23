open Core
open Olox_lib

let%expect_test "evaluate" = 
"
// Note: This is just for the expression evaluating chapter which evaluates an
// expression directly.
print (5 - (3 - 1)) + -1;
// expect: 2
"
|> Interpreter.interpret;
;;
    