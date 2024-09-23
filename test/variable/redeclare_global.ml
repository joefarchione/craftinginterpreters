open Core
open Olox_lib

(*FIXME*)
let%expect_test "redeclare_global" = 
"
var a = \"1\";
var a;
print a; // expect: nil
"
|> Interpreter.interpret;
  [%expect {| resover error: Already a variable in this scope with name 'a' |}]
;;
    