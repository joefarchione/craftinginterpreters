open Core
open Olox_lib

let%expect_test "undefined" = 
"
unknown = \"what\"; // expect runtime error: Undefined variable 'unknown'.
"
|> Interpreter.interpret;
;;
    