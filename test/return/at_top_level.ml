open Core
open Olox_lib

let%expect_test "at_top_level" = 
"
return \"wat\"; // Error at 'return': Can't return from top-level code.
"
|> Interpreter.interpret;
;;
    