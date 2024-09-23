open Core
open Olox_lib

let%expect_test "extra_arguments" = 
"
fun f(a, b) {
  print a;
  print b;
}

f(1, 2, 3, 4); // expect runtime error: Expected 2 arguments but got 4.
"
|> Interpreter.interpret;
;;
    