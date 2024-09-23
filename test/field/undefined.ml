open Core
open Olox_lib

let%expect_test "undefined" = 
"
class Foo {}
var foo = Foo();

foo.bar; // expect runtime error: Undefined property 'bar'.
"
|> Interpreter.interpret;
;;
    