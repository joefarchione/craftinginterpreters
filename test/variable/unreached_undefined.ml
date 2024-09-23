open Core
open Olox_lib

(*FIXME*)
let%expect_test "unreached_undefined" = 
"
if (false) {
  print notDefined;
}

print \"ok\"; // expect: ok
"
|> Interpreter.interpret;
  [%expect {| message='Expected expression' at line 2 for lexeme='{' |}]
;;
    