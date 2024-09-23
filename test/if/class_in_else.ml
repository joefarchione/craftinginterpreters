open Core
open Olox_lib

let%expect_test "class_in_else" = 
"
// [line 2] Error at 'class': Expect expression.
if (true) \"ok\"; else class Foo {}
"
|> Interpreter.interpret;
;;
    