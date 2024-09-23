open Core
open Olox_lib

let%expect_test "decimal_point_at_eof" = 
"
// [line 2] Error at end: Expect property name after '.'.
123."
|> Interpreter.interpret;
  [%expect {| message='Expect ';' after value' at line -1 for lexeme='EOF' |}]
;;
    