open Core
open Olox_lib

let%expect_test "trailing_dot" = 
"
// [line 2] Error at ';': Expect property name after '.'.
123.;
"
|> Interpreter.interpret;
  [%expect {| |}]
;;
    