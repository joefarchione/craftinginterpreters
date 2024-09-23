open Core
open Olox_lib

let%expect_test "after_else" = 
"
fun f() {
  if (false) \"no\"; else return \"ok\";
}

print f(); // expect: ok
"
|> Interpreter.interpret;
;;
    