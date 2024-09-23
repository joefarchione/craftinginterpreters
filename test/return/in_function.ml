open Core
open Olox_lib

let%expect_test "in_function" = 
"
fun f() {
  return \"ok\";
  print \"bad\";
}

print f(); // expect: ok
"
|> Interpreter.interpret;
;;
    