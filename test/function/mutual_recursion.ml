open Core
open Olox_lib

let%expect_test "mutual_recursion" = 
"
fun isEven(n) {
  if (n == 0) return true;
  return isOdd(n - 1);
}

fun isOdd(n) {
  if (n == 0) return false;
  return isEven(n - 1);
}

print isEven(4); // expect: true
print isOdd(3); // expect: true
"
|> Interpreter.interpret;
;;
    