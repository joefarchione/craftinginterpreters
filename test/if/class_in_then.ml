open Core
open Olox_lib

let%expect_test "class_in_then" = 
"
// [line 2] Error at 'class': Expect expression.
if (true) class Foo {}
"
|> Interpreter.interpret;
;;
    