open Core
open Olox_lib

let%expect_test "missing_arguments" = 
"
class Foo {
  method(a, b) {}
}

Foo().method(1); // expect runtime error: Expected 2 arguments but got 1.
"
|> Interpreter.interpret;
;;
    