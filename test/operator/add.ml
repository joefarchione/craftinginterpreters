open Core
open Olox_lib

let%expect_test "add" = 
"
print 123 + 456; // expect: 579
print \"str\" + \"ing\"; // expect: string
"
|> Interpreter.interpret;
;;
    