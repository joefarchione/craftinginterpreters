open Core
open Olox_lib

let%expect_test "get_on_function" = 
"
fun foo() {}

foo.bar; // expect runtime error: Only instances have properties.
"
|> Interpreter.interpret;
  [%expect {| runtime error: bar |}]
;;
    