open Core
open Olox_lib

let%expect_test "arguments" = 
"
class Foo {
  init(a, b) {
    print \"init\"; // expect: init
    this.a = a;
    this.b = b;
  }
}

var foo = Foo(1, 2);
print foo.a; // expect: 1
print foo.b; // expect: 2
"
|> Interpreter.interpret;
  [%expect {|
    init
    runtime error: this
    |}]
;;
    