open Core
open Olox_lib

let%expect_test "inherit_self" = 
"
class Foo < Foo {} // Error at 'Foo': A class can't inherit from itself.
"
|> Interpreter.interpret;
  [%expect {| Resover error : Foo A class cannot inherit from itself. |}]
;;
    