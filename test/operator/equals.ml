open Core
open Olox_lib

let%expect_test "equals" = 
"
print nil == nil; // expect: true

print true == true; // expect: true
print true == false; // expect: false

print 1 == 1; // expect: true
print 1 == 2; // expect: false

print \"str\" == \"str\"; // expect: true
print \"str\" == \"ing\"; // expect: false

print nil == false; // expect: false
print false == 0; // expect: false
print 0 == \"0\"; // expect: false
"
|> Interpreter.interpret;
  [%expect {|
    true
    true
    false
    true
    false
    true
    false
    false
    false
    false
    |}]
;;
    