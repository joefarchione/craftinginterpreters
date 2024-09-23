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
  [%expect {| runtime error: Invalid assignment target '(This { tag = THIS; lexeme = "this"; literal = LoxNil; line = 4 })' |}]
;;
    