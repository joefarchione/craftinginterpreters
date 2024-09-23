open Core
open Olox_lib

let%expect_test "redeclare_global" = 
"
var a = \"1\";
var a;
print a; // expect: nil
"
|> Interpreter.interpret;
;;
    