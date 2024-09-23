open Core
open Olox_lib

let%expect_test "set_evaluation_order" = 
"
undefined1.bar // expect runtime error: Undefined variable 'undefined1'.
  = undefined2;"
|> Interpreter.interpret;
  [%expect {| runtime error: Undefined variable undefined1 |}]
;;
    