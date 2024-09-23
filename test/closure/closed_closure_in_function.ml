open Core
open Olox_lib

let%expect_test "closed_closure_in_function" = 
"
var f;

{
  var local = \"local\";
  fun f_() {
    print local;
  }
  f = f_;
}

f(); // expect: local
"
|> Interpreter.interpret;
;;
    