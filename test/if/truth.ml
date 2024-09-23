open Core
open Olox_lib

let%expect_test "truth" = 
"
// False and nil are false.
if (false) print \"bad\"; else print \"false\"; // expect: false
if (nil) print \"bad\"; else print \"nil\"; // expect: nil

// Everything else is true.
if (true) print true; // expect: true
if (0) print 0; // expect: 0
if (\"\") print \"empty\"; // expect: empty
"
|> Interpreter.interpret;
;;
    