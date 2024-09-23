open Core
open Olox_lib

let%expect_test "extra_arguments" = 
"
class Foo {
  init(a, b) {
    this.a = a;
    this.b = b;
  }
}

var foo = Foo(1, 2, 3, 4); // expect runtime error: Expected 2 arguments but got 4."
|> Interpreter.interpret;
;;
    