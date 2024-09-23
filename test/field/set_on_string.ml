open Core
open Olox_lib

let%expect_test "set_on_string" = 
"
\"str\".foo = \"value\"; // expect runtime error: Only instances have fields.
"
|> Interpreter.interpret;
  [%expect {| runtime error: foo |}]
;;
    