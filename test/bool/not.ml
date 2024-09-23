open Core
open Olox_lib

let%expect_test "not" = 
"
print !true;    // expect: false
print !false;   // expect: true
print !!true;   // expect: true
"
|> Interpreter.interpret;
  [%expect {|
    false
    true
    true
    |}]
;;
    