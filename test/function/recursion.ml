open Core
open Olox_lib

let%expect_test "recursion" = 
"
fun fib(n) {
  if (n < 2) return n;
  return fib(n - 1) + fib(n - 2);
}

print fib(8); // expect: 21
"
|> Interpreter.interpret;
;;
    