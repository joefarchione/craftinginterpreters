open Core
open Olox_lib

let%expect_test "empty_body" = 
"
fun f() {}
print f(); // expect: nil
"
|> Interpreter.interpret;
;;
    