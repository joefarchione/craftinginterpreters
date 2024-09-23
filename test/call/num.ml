open Core
open Olox_lib

let%expect_test "num" = 
"
123(); // expect runtime error: Can only call functions and classes.
"
|> Interpreter.interpret;
;;
    