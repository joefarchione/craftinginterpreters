open Core
open Olox_lib

let%expect_test "after_if" = 
"
fun f() {
  if (true) return \"ok\";
}

print f(); // expect: ok
"
|> Interpreter.interpret;
;;
    