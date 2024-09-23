open Core
open Olox_lib

let%expect_test "return_closure" = 
"
fun f() {
  for (;;) {
    var i = \"i\";
    fun g() { print i; }
    return g;
  }
}

var h = f();
h(); // expect: i
"
|> Interpreter.interpret;
;;
    