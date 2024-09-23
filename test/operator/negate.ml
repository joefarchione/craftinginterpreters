open Core
open Olox_lib

let%expect_test "negate" = 
"
print -(3); // expect: -3
print --(3); // expect: 3
print ---(3); // expect: -3
"
|> Interpreter.interpret;
;;
    