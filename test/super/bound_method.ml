open Core
open Olox_lib

let%expect_test "bound_method" = 
"
class A {
  method(arg) {
    print \"A.method(\" + arg + \")\";
  }
}

class B < A {
  getClosure() {
    return super.method;
  }

  method(arg) {
    print \"B.method(\" + arg + \")\";
  }
}


var closure = B().getClosure();
closure(\"arg\"); // expect: A.method(arg)
"
|> Interpreter.interpret;
;;
    