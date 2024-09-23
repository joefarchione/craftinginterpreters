open Core
open Olox_lib

let%expect_test "set_on_nil" = 
"
nil.foo = \"value\"; // expect runtime error: Only instances have fields.
"
|> Interpreter.interpret;
;;
    