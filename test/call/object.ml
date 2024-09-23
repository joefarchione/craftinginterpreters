open Core
open Olox_lib

let%expect_test "object" = 
"
class Foo {}

var foo = Foo();
foo(); // expect runtime error: Can only call functions and classes.
"
|> Interpreter.interpret;
;;
    