open Core
open Olox_lib

let%expect_test "fun_in_body" = 
"
// [line 2] Error at 'fun': Expect expression.
while (true) fun foo() {}
"
|> Interpreter.interpret;
;;
    