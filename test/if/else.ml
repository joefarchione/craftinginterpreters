open Core
open Olox_lib

let%expect_test "else" = 
"
// Evaluate the 'else' expression if the condition is false.
if (true) print \"good\"; else print \"bad\"; // expect: good
if (false) print \"bad\"; else print \"good\"; // expect: good

// Allow block body.
if (false) nil; else { print \"block\"; } // expect: block
"
|> Interpreter.interpret;
  [%expect {|
    good
    good
    block
    |}]
;;
    