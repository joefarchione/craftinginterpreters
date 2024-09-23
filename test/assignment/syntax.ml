open Core
open Olox_lib

let%expect_test "syntax" = 
"
// Assignment on RHS of variable.
var a = \"before\";
var c = a = \"var\";
print a; // expect: var
print c; // expect: var
"
|> Interpreter.interpret;
  [%expect {| varvar |}]
;;
    