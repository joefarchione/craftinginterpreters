open Core
open Olox_lib

let%expect_test "to_this" = 
"
class Foo {
  Foo() {
    this = \"value\"; // Error at '=': Invalid assignment target.
  }
}

Foo();
"
|> Interpreter.interpret;
;;
    