open Core
open Olox_lib

let%expect_test "line_at_eof" = 
"
print \"ok\"; // expect: ok
// comment"
|> Interpreter.interpret;
  [%expect {| ok |}];;
;;
    