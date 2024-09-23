open Core
open Olox_lib

let%expect_test "local_inherit_other" = 
"
class A {}

fun f() {
  class B < A {}
  return B;
}

print f(); // expect: B
"
|> Interpreter.interpret;
;;
    