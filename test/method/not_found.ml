open Core
open Olox_lib

let%expect_test "not_found" = 
"
class Foo {}

Foo().unknown(); // expect runtime error: Undefined property 'unknown'.
"
|> Interpreter.interpret;
  [%expect {| runtime error: No property |}]
;;
    