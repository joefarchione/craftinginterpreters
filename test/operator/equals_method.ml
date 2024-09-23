open Core
open Olox_lib

let%expect_test "equals_method" = 
"
// Bound methods have identity equality.
class Foo {
  method() {}
}

var foo = Foo();
var fooMethod = foo.method;

// Same bound method.
print fooMethod == fooMethod; // expect: true

// Different closurizations.
print foo.method == foo.method; // expect: false
"
|> Interpreter.interpret;
  [%expect {|
    true
    true
    |}]
;;
    