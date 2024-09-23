open Core
open Olox_lib

let%expect_test "get_on_string" = 
"
\"str\".foo; // expect runtime error: Only instances have properties.
"
|> Interpreter.interpret;
;;
    