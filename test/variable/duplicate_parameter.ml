open Core
open Olox_lib

let%expect_test "duplicate_parameter" = 
"
fun foo(arg,
        arg) { // Error at 'arg': Already a variable with this name in this scope.
  \"body\";
}
"
|> Interpreter.interpret;
;;
    