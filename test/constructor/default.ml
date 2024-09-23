open Core
open Olox_lib

let%expect_test "default" = 
"
class Foo {}

var foo = Foo();
print foo; // expect: Foo instance
"
|> Interpreter.interpret;
  [%expect {| Instance of Foo |}]
;;
    