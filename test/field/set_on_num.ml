open Core
open Olox_lib

let%expect_test "set_on_num" = 
"
123.foo = \"value\"; // expect runtime error: Only instances have fields.
"
|> Interpreter.interpret;
  [%expect {| message='Expect ';' after value' at line 2 for lexeme='foo' |}]
;;
    