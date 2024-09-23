open Core
open Olox_lib

let%expect_test "statement_condition" = 
"
// [line 3] Error at '{': Expect expression.
// [line 3] Error at ')': Expect ';' after expression.
for (var a = 1; {}; a = a + 1) {}
"
|> Interpreter.interpret;
;;
    