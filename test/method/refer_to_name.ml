open Core
open Olox_lib

let%expect_test "refer_to_name" = 
"
class Foo {
  method() {
    print method; // expect runtime error: Undefined variable 'method'.
  }
}

Foo().method();
"
|> Interpreter.interpret;
;;
    