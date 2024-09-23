open Core
open Olox_lib

let%expect_test "this_at_top_level" = 
"
this; // Error at 'this': Can't use 'this' outside of a class.
"
|> Interpreter.interpret;
;;
    