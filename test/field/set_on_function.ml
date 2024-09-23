open Core
open Olox_lib

let%expect_test "set_on_function" = 
"
fun foo() {}

foo.bar = \"value\"; // expect runtime error: Only instances have fields.
"
|> Interpreter.interpret;
;;
    