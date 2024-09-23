open Core
open Olox_lib

let%expect_test "print_bound_method" = 
"
class Foo {
  method() { }
}
var foo = Foo();
print foo.method; // expect: <fn method>
"
|> Interpreter.interpret;
;;
    