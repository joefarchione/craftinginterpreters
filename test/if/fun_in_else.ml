open Core
open Olox_lib

let%expect_test "fun_in_else" = 
"
// [line 2] Error at 'fun': Expect expression.
if (true) \"ok\"; else fun foo() {}
"
|> Interpreter.interpret;
;;
    