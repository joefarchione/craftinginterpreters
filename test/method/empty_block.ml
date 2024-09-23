open Core
open Olox_lib

let%expect_test "empty_block" = 
"
class Foo {
  bar() {}
}

print Foo().bar(); // expect: nil
"
|> Interpreter.interpret;
;;
    