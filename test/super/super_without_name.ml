open Core
open Olox_lib

let%expect_test "super_without_name" = 
"
class A {}

class B < A {
  method() {
    super.; // Error at ';': Expect superclass method name.
  }
}
"
|> Interpreter.interpret;
;;
    