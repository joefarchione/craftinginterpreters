open Core
open Olox_lib

let%expect_test "negate_nonnum" = 
"
-\"s\"; // expect runtime error: Operand must be a number.
"
|> Interpreter.interpret;
  [%expect {| runtime error: Not a number |}]
;;
    