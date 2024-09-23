open Core
open Olox_lib

let%expect_test "close_over_function_parameter" = 
"
var f;

fun foo(param) {
  fun f_() {
    print param;
  }
  f = f_;
}
foo(\"param\");

f(); // expect: param
"
|> Interpreter.interpret;
;;
    