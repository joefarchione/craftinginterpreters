open Core
open Olox_lib

let%expect_test "reference_closure_multiple_times" = 
"
var f;

{
  var a = \"a\";
  fun f_() {
    print a;
    print a;
  }
  f = f_;
}

f();
// expect: a
// expect: a
"
|> Interpreter.interpret;
;;
    