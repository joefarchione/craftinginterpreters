open Core
open Olox_lib

let%expect_test "unreached_undefined" = 
"
if (false) {
  print notDefined;
}

print \"ok\"; // expect: ok
"
|> Interpreter.interpret;
;;
    