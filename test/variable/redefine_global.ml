open Core
open Olox_lib

let%expect_test "redefine_global" = 
"
var a = \"1\";
var a = \"2\";
print a; // expect: 2
"
|> Interpreter.interpret;
;;
    