open Core
open Olox_lib

let%expect_test "collide_with_parameter" = 
"
fun foo(a) {
  var a; // Error at 'a': Already a variable with this name in this scope.
}
"
|> Interpreter.interpret;
;;
    