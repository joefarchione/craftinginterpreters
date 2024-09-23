open Core
open Olox_lib

let%expect_test "statement_increment" = 
"
// [line 2] Error at '{': Expect expression.
for (var a = 1; a < 2; {}) {}
"
|> Interpreter.interpret;
;;
    