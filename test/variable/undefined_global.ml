open Core
open Olox_lib

let%expect_test "undefined_global" = 
"
print notDefined;  // expect runtime error: Undefined variable 'notDefined'.
"
|> Interpreter.interpret;
;;
    