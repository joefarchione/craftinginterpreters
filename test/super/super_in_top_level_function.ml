open Core
open Olox_lib

let%expect_test "super_in_top_level_function" = 
"
  super.bar(); // Error at 'super': Can't use 'super' outside of a class.
fun foo() {
}"
|> Interpreter.interpret;
;;
    