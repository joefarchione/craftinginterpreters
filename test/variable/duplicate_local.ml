open Core
open Olox_lib

let%expect_test "duplicate_local" = 
"
{
  var a = \"value\";
  var a = \"other\"; // Error at 'a': Already a variable with this name in this scope.
}
"
|> Interpreter.interpret;
  [%expect {| resover error: Already a variable in this scope with name 'a' |}]
;;
    