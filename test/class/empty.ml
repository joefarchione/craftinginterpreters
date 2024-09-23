open Core
open Olox_lib

let%expect_test "empty" = 
"
class Foo {}

print Foo; // expect: Foo
"
|> Interpreter.interpret;
;;
    