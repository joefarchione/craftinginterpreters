open Core
open Olox_lib

let%expect_test "get_on_bool" = 
"
true.foo; // expect runtime error: Only instances have properties.
"
|> Interpreter.interpret;
  [%expect {| runtime error: foo |}]
;;
    