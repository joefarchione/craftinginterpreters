open Core
open Olox_lib

let%expect_test "this_in_top_level_function" = 
"
fun foo() {
  this; // Error at 'this': Can't use 'this' outside of a class.
}
"
|> Interpreter.interpret;
  [%expect {| resover error: 'this' can't use this outside of a class |}]
;;
    