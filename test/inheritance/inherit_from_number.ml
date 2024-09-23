open Core
open Olox_lib

let%expect_test "inherit_from_number" = 
"
var Number = 123;
class Foo < Number {} // expect runtime error: Superclass must be a class.
"
|> Interpreter.interpret;
;;
    