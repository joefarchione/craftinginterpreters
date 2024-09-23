open Core
open Olox_lib

let%expect_test "missing_comma_in_parameters" = 
"
// [line 3] Error at 'c': Expect ')' after parameters.
// [c line 4] Error at end: Expect '}' after block.
fun foo(a, b c, d, e, f) {}
"
|> Interpreter.interpret;
;;
    