open Core
open Olox_lib

let%expect_test "local_from_method" = 
"
var foo = \"variable\";

class Foo {
  method() {
    print foo;
  }
}

Foo().method(); // expect: variable
"
|> Interpreter.interpret;
;;
    