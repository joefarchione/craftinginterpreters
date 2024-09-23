open Core
open Olox_lib

let%expect_test "parenthesized" = 
"
class A {
  method() {}
}

class B < A {
  method() {
    // [line 8] Error at ')': Expect '.' after 'super'.
    (super).method();
  }
}
"
|> Interpreter.interpret;
;;
    