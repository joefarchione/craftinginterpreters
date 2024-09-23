open Core
open Olox_lib

let%expect_test "multiply" = 
"
print 5 * 3; // expect: 15
print 12.34 * 0.3; // expect: 3.702
"
|> Interpreter.interpret;
;;
    