open Core
open Olox_lib

let%expect_test "grouping" = 
"
var a = \"a\";
(a) = \"value\"; // Error at '=': Invalid assignment target.
"
|> Interpreter.interpret;
  [%expect {| 3 =  Expect ';' after value |}]
;;
    