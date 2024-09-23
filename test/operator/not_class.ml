open Core
open Olox_lib

let%expect_test "not_class" = 
"
class Bar {}
print !Bar;      // expect: false
print !Bar();    // expect: false
"
|> Interpreter.interpret;
;;
    