open Core
open Olox_lib

let%expect_test "not_equals" = 
"
print nil != nil; // expect: false

print true != true; // expect: false
print true != false; // expect: true

print 1 != 1; // expect: false
print 1 != 2; // expect: true

print \"str\" != \"str\"; // expect: false
print \"str\" != \"ing\"; // expect: true

print nil != false; // expect: true
print false != 0; // expect: true
print 0 != \"0\"; // expect: true
"
|> Interpreter.interpret;
  [%expect {|
    false
    false
    true
    false
    true
    false
    true
    true
    true
    true
    |}]
;;
    