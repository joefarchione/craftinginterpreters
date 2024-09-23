open Core
open Olox_lib

let%expect_test "regression394" = 
"
{
  class A {}
  class B < A {}
  print B; // expect: B
}
"
|> Interpreter.interpret;
  [%expect {| B |}]
;;
    