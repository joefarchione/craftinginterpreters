open Core
open Olox_lib

let%expect_test "default_arguments" = 
"
class Foo {}

var foo = Foo(1, 2, 3); // expect runtime error: Expected 0 arguments but got 3.
"
|> Interpreter.interpret;
;;
    