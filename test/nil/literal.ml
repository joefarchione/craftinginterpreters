open Core
open Olox_lib

let%expect_test "literal" = 
"
print nil; // expect: nil
"
|> Interpreter.interpret;
;;
    