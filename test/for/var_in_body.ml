open Core
open Olox_lib

let%expect_test "var_in_body" = 
"
// [line 2] Error at 'var': Expect expression.
for (;;) var foo;
"
|> Interpreter.interpret;
;;
    