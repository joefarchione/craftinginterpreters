open Core
open Olox_lib

let%expect_test "instantiation" = 
"
// This benchmark stresses instance creation and initializer calling.

class Foo {
  init() {}
}

var start = clock();
var i = 0;
while (i < 500000) {
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  Foo();
  i = i + 1;
}

print clock() - start;
"
|> Interpreter.interpret;
;;
    