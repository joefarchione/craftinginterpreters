open Core
open Olox_lib

let%expect_test "return_inside" = 
"
fun f() {
  while (true) {
    var i = \"i\";
    return i;
  }
}

print f();
// expect: i
"
|> Interpreter.interpret;
;;
    