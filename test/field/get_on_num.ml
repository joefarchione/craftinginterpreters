open Core
open Olox_lib

let%expect_test "get_on_num" = 
"
123.foo; // expect runtime error: Only instances have properties.
"
|> Interpreter.interpret;
  [%expect {| message='Expect ';' after value' at line 2 for lexeme='foo' |}]
;;
    