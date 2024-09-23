open Core
open Olox_lib

let%expect_test "uninitialized" = 
"
var a;
print a; // expect: nil
"
|> Interpreter.interpret;
;;
    