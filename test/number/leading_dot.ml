open Core
open Olox_lib

let%expect_test "leading_dot" = 
"
// [line 2] Error at '.': Expect expression.
.123;
"
|> Interpreter.interpret;
  [%expect {| message='Expected expression' at line 3 for lexeme='.' |}]
;;
    