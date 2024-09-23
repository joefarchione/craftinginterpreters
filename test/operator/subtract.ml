open Core
open Olox_lib

let%expect_test "subtract" = 
"
print 4 - 3; // expect: 1
print 1.2 - 1.2; // expect: 0
"
|> Interpreter.interpret;
  [%expect {|
    1
    0
    |}]
;;
    