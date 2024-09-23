open Core
open Olox_lib

let%expect_test "call_nonfunction_field" = 
"
class Foo {}

var foo = Foo();
foo.bar = \"not fn\";

foo.bar(); // expect runtime error: Can only call functions and classes.
"
|> Interpreter.interpret;
;;
    