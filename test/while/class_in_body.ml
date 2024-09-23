open Core
open Olox_lib

let%expect_test "class_in_body" = 
"
// [line 2] Error at 'class': Expect expression.
while (true) class Foo {}
"
|> Interpreter.interpret;
;;
    