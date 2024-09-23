open Core
open Olox_lib

let%expect_test "return_nil_if_no_value" = 
"
fun f() {
  return;
  print \"bad\";
}

print f(); // expect: nil
"
|> Interpreter.interpret;
;;
    