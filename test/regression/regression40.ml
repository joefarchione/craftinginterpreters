open Core
open Olox_lib

let%expect_test "regression40" = 
"
fun caller(g) {
  g();
  // g should be a function, not nil.
  print g == nil; // expect: false
}

fun callCaller() {
  var capturedVar = \"before\";
  var a = \"a\";

  fun f() {
    // Commenting the next line out prevents the bug!
    capturedVar = \"after\";

    // Returning anything also fixes it, even nil:
    //return nil;
  }

  caller(f);
}

callCaller();
"
|> Interpreter.interpret;
  [%expect {| runtime error: Undefined variable 'capturedVar'. |}]
;;
    