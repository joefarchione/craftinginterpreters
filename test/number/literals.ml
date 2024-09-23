open Core
open Olox_lib

let%expect_test "literals" = 
"
print 123;     // expect: 123
print 987654;  // expect: 987654
print 0;       // expect: 0
print -0;      // expect: -0

print 123.456; // expect: 123.456
print -0.001;  // expect: -0.001
"
|> Interpreter.interpret;
  [%expect {|
    123
    987654
    0
    -0
    123.456
    -0.001
    |}]
;;
    