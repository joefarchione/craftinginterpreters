open Core
open Olox_lib

let%expect_test "return_value" = 
"
class Foo {
  init() {
    return \"result\"; // Error at 'return': Can't return a value from an initializer.
  }
}
"
|> Interpreter.interpret;
;;
    