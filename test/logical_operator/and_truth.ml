open Core
open Olox_lib

let%expect_test "and_truth" = 
"
// False and nil are false.
print false and \"bad\"; // expect: false
print nil and \"bad\"; // expect: nil

// Everything else is true.
print true and \"ok\"; // expect: ok
print 0 and \"ok\"; // expect: ok
print \"\" and \"ok\"; // expect: ok
"
|> Interpreter.interpret;
;;
    