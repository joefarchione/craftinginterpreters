open Core
open Olox_lib

let%expect_test "after_while" = 
"
fun f() {
  while (true) return \"ok\";
}

print f(); // expect: ok
"
|> Interpreter.interpret;
  [%expect {| ok |}]
;;
    