open Core
open Olox_lib

let%expect_test "missing_argument" = 
"
// [line 2] Error at ';': Expect expression.
print;
"
|> Interpreter.interpret;
;;
    