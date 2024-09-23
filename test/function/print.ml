open Core
open Olox_lib

let%expect_test "print" = 
"
fun foo() {}
print foo; // expect: <fn foo>

print clock; // expect: <native fn>
"
|> Interpreter.interpret;
;;
    