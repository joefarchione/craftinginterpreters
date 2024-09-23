open Core
open Olox_lib

let%expect_test "inherit_from_function" = 
"
fun foo() {}

class Subclass < foo {} // expect runtime error: Superclass must be a class.
"
|> Interpreter.interpret;
;;
    