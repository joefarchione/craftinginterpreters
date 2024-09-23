open Core
open Olox_lib

let%expect_test "prefix_operator" = 
"
var a = \"a\";
!a = \"value\"; // Error at '=': Invalid assignment target.
"
|> Interpreter.interpret;
  [%expect {| 3 =  Incorrect tag for primary expression |}]
;;
    