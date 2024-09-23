open Core
open Olox_lib

let%expect_test "inherit_from_nil" = 
"
var Nil = nil;
class Foo < Nil {} // expect runtime error: Superclass must be a class.
"
|> Interpreter.interpret;
;;
    