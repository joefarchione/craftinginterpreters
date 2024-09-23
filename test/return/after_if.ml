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
  [%expect {| message='Expected expression' at line 3 for lexeme='return' |}]
;;
    