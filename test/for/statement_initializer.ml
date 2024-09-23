open Core
open Olox_lib

let%expect_test "statement_initializer" = 
"
// [line 3] Error at '{': Expect expression.
// [line 3] Error at ')': Expect ';' after expression.
for ({}; a < 2; a = a + 1) {}
"
|> Interpreter.interpret;
;;
    