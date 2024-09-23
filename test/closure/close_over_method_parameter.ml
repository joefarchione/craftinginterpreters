open Core
open Olox_lib

let%expect_test "close_over_method_parameter" = 
"
var f;

class Foo {
  method(param) {
    fun f_() {
      print param;
    }
    f = f_;
  }
}

Foo().method(\"param\");
f(); // expect: param
"
|> Interpreter.interpret;
;;
    