open Core
open Olox_lib

let%expect_test "var_in_else" = 
"
// [line 2] Error at 'var': Expect expression.
if (true) \"ok\"; else var foo;
"
|> Interpreter.interpret;
;;
    