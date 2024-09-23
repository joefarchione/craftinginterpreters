open Core
open Olox_lib

let%expect_test "get_on_nil" = 
"
nil.foo; // expect runtime error: Only instances have properties.
"
|> Interpreter.interpret;
;;
    