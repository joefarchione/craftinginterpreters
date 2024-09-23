open Core
open Olox_lib

let%expect_test "divide" = 
"
print 8 / 2;         // expect: 4
print 12.34 / 12.34;  // expect: 1
"
|> Interpreter.interpret;
  [%expect {|
    4
    1
    |}]
;;
    