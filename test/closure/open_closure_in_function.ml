open Core
open Olox_lib

let%expect_test "open_closure_in_function" = 
"
{
  var local = \"local\";
  fun f() {
    print local; // expect: local
  }
  f();
}
"
|> Interpreter.interpret;
;;
    