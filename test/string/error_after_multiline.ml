open Core
open Olox_lib

let%expect_test "error_after_multiline" = 
"
// Tests that we correctly track the line info across multiline strings.
var a = \"1
2
3
\";

err; // // expect runtime error: Undefined variable 'err'."
|> Interpreter.interpret;
;;
    