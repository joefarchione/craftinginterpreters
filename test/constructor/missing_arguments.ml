open Core
open Olox_lib

let%expect_test "missing_arguments" = 
"
class Foo {
  init(a, b) {}
}

var foo = Foo(1); // expect runtime error: Expected 2 arguments but got 1.
"
|> Interpreter.interpret;
  [%expect {| Number of arguments supplied less than number of parameters |}]
;;
    