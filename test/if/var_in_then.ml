open Core
open Olox_lib

let%expect_test "var_in_then" = 
"
// [line 2] Error at 'var': Expect expression.
if (true) var foo;
"
|> Interpreter.interpret;
;;
    