open Core
open Olox_lib

let%expect_test "unterminated" = 
"
// [line 2] Error: Unterminated string.
\"this string has no close quote"
|> Interpreter.interpret;
;;
    