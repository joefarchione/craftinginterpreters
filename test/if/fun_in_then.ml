open Core
open Olox_lib

let%expect_test "fun_in_then" = 
"
// [line 2] Error at 'fun': Expect expression.
if (true) fun foo() {}
"
|> Interpreter.interpret;
;;
    