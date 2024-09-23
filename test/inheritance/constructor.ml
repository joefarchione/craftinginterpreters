open Core
open Olox_lib

let%expect_test "constructor" = 
"
class A {
  init(param) {
    this.field = param;
  }

  test() {
    print this.field;
  }
}

class B < A {}

var b = B(\"value\");
b.test(); // expect: value
"
|> Interpreter.interpret;
;;
    