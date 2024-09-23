open Core
open Olox_lib

let%expect_test "unterminated" = 
"
// [line 2] Error: Unterminated string.
\"this string has no close quote"
|> Interpreter.interpret;
  [%expect {| message='Unterminated string' at line 3 for lexeme='EOF' |}];;
;;
    