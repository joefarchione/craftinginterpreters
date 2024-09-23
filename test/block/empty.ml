open Core
open Olox_lib

let%expect_test "empty" = 
"
{} // By itself.

// In a statement.
if (true) {}
if (false) {} else {}

print \"ok\"; // expect: ok
"
|> Interpreter.interpret;
  [%expect {| ok |}]
;;
    