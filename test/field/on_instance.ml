open Core
open Olox_lib

let%expect_test "on_instance" = 
"
class Foo {}

var foo = Foo();

print foo.bar = \"bar value\"; // expect: bar value
print foo.baz = \"baz value\"; // expect: baz value

print foo.bar; // expect: bar value
print foo.baz; // expect: baz value
"
|> Interpreter.interpret;
  [%expect {|
    Instance of Foo
    Instance of Foo
    bar value
    baz value
    |}]
;;
    