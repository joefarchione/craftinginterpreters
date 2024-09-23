open Core
open Olox_lib

let%expect_test "nil" = 
"
nil(); // expect runtime error: Can only call functions and classes.
"
|> Interpreter.interpret;
;;
    