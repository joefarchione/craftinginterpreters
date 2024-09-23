open Core
open Olox_lib

let%expect_test "literal" = 
"
print nil; // expect: nil
"
|> Interpreter.interpret;
  [%expect {| message='Expected expression' at line 3 for lexeme='' |}]
;;
    