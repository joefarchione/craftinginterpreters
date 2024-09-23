open Core
open Olox_lib

let%expect_test "infix_operator" = 
"
var a = \"a\";
var b = \"b\";
a + b = \"value\"; // Error at '=': Invalid assignment target.
"
|> Interpreter.interpret;
  [%expect {| 4 =  Expect ';' after value |}]
;;
    