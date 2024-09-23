open Core
open Olox_lib

let%expect_test "super_without_dot" = 
"
class A {}

class B < A {
  method() {
    // [line 6] Error at ';': Expect '.' after 'super'.
    super;
  }
}
"
|> Interpreter.interpret;
;;
    