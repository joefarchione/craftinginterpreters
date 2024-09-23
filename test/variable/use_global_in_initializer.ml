open Core
open Olox_lib

let%expect_test "use_global_in_initializer" = 
"
var a = \"value\";
var a = a;
print a; // expect: value
"
|> Interpreter.interpret;
;;
    